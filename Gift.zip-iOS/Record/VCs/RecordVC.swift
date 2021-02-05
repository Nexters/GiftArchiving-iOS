//
//  RecordVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/26.
//

import UIKit
import RxCocoa
import RxSwift

enum FrameOfImage {
    case square
    case circle
    case windowFrame
}

class RecordVC: UIViewController {
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var cropImageView: UIImageView!
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var stickerArea: UIView!
    @IBOutlet weak var emotionTextView: UITextView!
    @IBOutlet weak var bottomBarBottomConstraintWithBottomSafeArea: NSLayoutConstraint!
    @IBOutlet weak var upperContainerConstraintWithImageContainerTop: NSLayoutConstraint!
    @IBOutlet weak var emptyImageLabel: UILabel!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var purposeImageView: UIImageView!
    @IBOutlet weak var emotionImageView: UIImageView!
    @IBOutlet weak var dateToRecordLabel: UILabel!
    
    lazy var picker = UIImagePickerController()
    
    lazy var popupBackground = UIView()
    
    lazy var stickerView = StickerView()
    
    private var textViewPlaceholderFlag: Bool = true
    
    private var originalFullImage: UIImage? // full Image
    
    var editedImage: UIImage? // cropped Image
    
    private var currentFrameOfImage: FrameOfImage = .square
    
    private var currentInfoViewOriginY: CGFloat = 0
    
    private var currentBottomContainerOriginY: CGFloat = 0
    
    private var currentImageContainerOriginY: CGFloat = 0
    
    private var currentBackgroundColor: UIColor = UIColor.charcoalGrey
    
    private var isStickerEditing: Bool = false
    
    private var isSend: Bool = false
    
    private var dateToRecord: String = "" {
        didSet {
            dateToRecordLabel.text = dateToRecord
        }
    }
    let disposeBag = DisposeBag()
    
    private var isNameTouched: Bool = false
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
        setNotificationCenter()
        initTextField()
        initializeDelegates()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dateSegue" {
            popupBackground.animatePopupBackground(true)
            guard let des = segue.destination as? DatePopupVC else { return }
            des.delegate = self
        } else if segue.identifier == "categoryPopup" {
            popupBackground.animatePopupBackground(true)
            view.bringSubviewToFront(categoryImageView)
            view.bringSubviewToFront(categoryLabel)
            guard let des = segue.destination as? IconPopupVC else { return }
            des.whichPopup = 0
            des.backgroundColor = currentBackgroundColor
            des.popupViewHeightByPhones = self.view.frame.height - infoView.frame.origin.y - 149 - 34
        } else if segue.identifier == "purposePopup" {
            popupBackground.animatePopupBackground(true)
            view.bringSubviewToFront(purposeImageView)
            view.bringSubviewToFront(purposeLabel)
            guard let des = segue.destination as? IconPopupVC else { return }
            des.whichPopup = 1
            des.backgroundColor = currentBackgroundColor
            des.popupViewHeightByPhones = self.view.frame.height - infoView.frame.origin.y - 149 - 34
        } else if segue.identifier == "emotionPopup" {
            popupBackground.animatePopupBackground(true)
            view.bringSubviewToFront(emotionImageView)
            view.bringSubviewToFront(emotionLabel)
            guard let des = segue.destination as? IconPopupVC else { return }
            des.whichPopup = 2
            des.backgroundColor = currentBackgroundColor
            
            des.isSend = self.isSend
            
            des.popupViewHeightByPhones = self.view.frame.height - infoView.frame.origin.y - 149 - 34
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func backToMain(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeRecord(_ sender: UIButton) {
        // record server
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "사진 선택", message: "되라제발", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeFrame(_ sender: UIButton) {
        let des = self.storyboard?.instantiateViewController(identifier: "ImageCropVC") as! ImageCropVC
        // image 및 프레임 설정
        des.image = originalFullImage
        des.frameOfImage = currentFrameOfImage
        // hole 크기 설정 , 스크롤 영역 설정
        des.modalPresentationStyle = .fullScreen
        present(des, animated: true, completion: nil)
    }
    
    @IBAction func useSticker(_ sender: UIButton) {
        if isStickerEditing {
            stickerView.animatePopupBackground(false)
            isStickerEditing = false
        } else {
            self.view.addSubview(stickerView)
            stickerView.translatesAutoresizingMaskIntoConstraints = false
            stickerView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0).isActive = true
            stickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            stickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            stickerView.topAnchor.constraint(equalTo: imageContainer
                                                .bottomAnchor, constant: 0).isActive = true
            isStickerEditing = true
        }
    }
}

//MARK: - Private Methods

extension RecordVC {
    
    private func setLayouts() {
        for button in buttons {
            button.makeRounded(cornerRadius: 8.0)
        }
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "이름",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(white: 1.0, alpha: 0.34)]
        )
        popupBackground.setPopupBackgroundView(to: view)
        emotionTextView.textColor = UIColor.white
        if textViewPlaceholderFlag {
            emotionTextView.text = "지금 이 감정을 기록해보세요."
            emotionTextView.alpha = 0.34
        } else {
            emotionTextView.alpha = 1.0
        }
        
        
        currentInfoViewOriginY = infoView.frame.origin.y
        currentBottomContainerOriginY = bottomContainer.frame.origin.y
        currentImageContainerOriginY = imageContainer.frame.origin.y
        cropImageView.makeDashedBorder()
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectIcon), name: .init("selectIcon"), object: nil)
    }
    
    @objc private func selectIcon(_ notification: Notification) {
        
        popupBackground.animatePopupBackground(false)
        view.bringSubviewToFront(popupBackground)
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let iconImage = userInfo["iconImageName"] as? String else { return }
        guard let iconName = userInfo["iconName"] as? String else { return }
        guard let iconKind = userInfo["iconKind"] as? String else { return }
        
        if iconKind == "category" {
            categoryImageView.image = UIImage(named: iconImage)
            categoryLabel.text = iconName
        } else if iconKind == "purpose" {
            purposeImageView.image = UIImage(named: iconImage)
            purposeLabel.text = iconName
        } else {
            emotionImageView.image = UIImage(named: iconImage)
            emotionLabel.text = iconName
        }
    }
    
    //    private func
    @objc private func keyboardWillShow(_ sender: Notification) {
        handleKeyboardIssue(sender, isAppearing: true)
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        handleKeyboardIssue(sender, isAppearing: false)
    }
    
    private func handleKeyboardIssue(_ notification: Notification, isAppearing: Bool) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return
        }
        // 기기별 bottom safearea 계산하기
        let heightConstant = isAppearing ? keyboardHeight - 34 : 0
        if isNameTouched {
            isNameTouched = false
            //            self.bottomBarBottomConstraintWithBottomSafeArea.constant = heightConstant
            //            self.view.layoutIfNeeded()
        } else {
            UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                if isAppearing {
                    self.upperContainerConstraintWithImageContainerTop.priority = UILayoutPriority(rawValue: 248)
                } else {
                    self.upperContainerConstraintWithImageContainerTop.priority = UILayoutPriority(rawValue: 1000)
                }
                self.bottomBarBottomConstraintWithBottomSafeArea.constant = heightConstant
                self.view.layoutIfNeeded()
            }) { (_) in
            }
        }
    }
    
    private func initTextField() {
        
        nameTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe { _ in
                if let text = self.nameTextField.text {
                    if text.isEmpty {
                        self.fromLabel.alpha = 0.34
                    } else {
                        self.fromLabel.alpha = 1
                    }
                }
                self.nameTextField.sizeToFit()
            }.disposed(by: disposeBag)
        
    }
    
    private func initializeDelegates() {
        nameTextField.delegate = self
        picker.delegate = self
        emotionTextView.delegate = self
    }
    
    
    private func openLibrary() {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
        
    }
    
}

//MARK: - UITextFieldDelegate

extension RecordVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isNameTouched = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameStackView.layoutIfNeeded()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RecordVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage, let editedImage = info[.editedImage] as? UIImage {
            print(image)
            self.cropImageView.image = editedImage
            self.cropImageView.eraseBorder()
            self.originalFullImage = image
            self.emptyImageLabel.isHidden = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func savedImage(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        if let error = error {
            print(error)
            return
        }
        print("success")
    }
}

//MARK: - UITextViewDelegate

extension RecordVC: UITextViewDelegate {
    
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textViewPlaceholderFlag {
            textView.text = nil
            textView.alpha = 1.0
            textViewPlaceholderFlag = false
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty {
            textView.text = "지금 이 감정을 기록해보세요."
            textView.alpha = 0.34
            textViewPlaceholderFlag = true
        } else {
            textViewPlaceholderFlag = false
        }
        
    }
}

//MARK: - PopupViewDelegate

extension RecordVC: PopupViewDelegate {
    
    func sendDateButtonTapped(_ date: Date?) {
        popupBackground.animatePopupBackground(false)
        if date == nil { return }
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd. "
        let todayDate = formatter.string(from: date!)
        
        dateToRecord = todayDate + getDayOfWeek(date!)
    }
    
    func sendIconDataButtonTapped() {
        popupBackground.animatePopupBackground(false)
        
    }
    
    func getDayOfWeek(_ today: Date) -> String {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: today)
        
        switch weekDay {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "NILL"
        }
    }
}
