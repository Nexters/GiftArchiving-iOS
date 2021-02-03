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
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var cropImageView: UIImageView!
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var stickerArea: UIView!
    @IBOutlet weak var emotionTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    lazy var picker = UIImagePickerController()
    
    lazy var popupBackground = UIView()
    
    private var textViewPlaceholderFlag: Bool = true
    
    private var originalFullImage: UIImage? // full Image
    
    var editedImage: UIImage? // cropped Image
    
    var frameImage: FrameOfImage = .square
    
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
    
    @IBAction func chooseType(_ sender: UIButton) {
    }
    
    @IBAction func chooseWhen(_ sender: UIButton) {
    }
    
    @IBAction func chooseEmotion(_ sender: UIButton) {
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
        des.image = originalFullImage
        des.modalPresentationStyle = .fullScreen
        present(des, animated: true, completion: nil)
//        let shiftyVC = ShiftyImageCropVC(frame: (view.frame), image: originalFullImage!, aspectWidth: 315, aspectHeight: 152)
//        shiftyVC.modalPresentationStyle = .fullScreen
//        self.present(shiftyVC, animated: true, completion: nil)
    }
    
    @IBAction func useSticker(_ sender: UIButton) {
//        let sticker
        
        
    }
}

//MARK: - Private Methods

extension RecordVC {
    
    private func setLayouts() {
        for button in buttons {
            button.makeRounded(cornerRadius: 12.0)
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
        
        cropImageView.layer.borderWidth = 1
        cropImageView.layer.borderColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.7).cgColor
        
        
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        
        if isNameTouched {
            isNameTouched = false
        } else {
            // 기기별 bottom safearea 계산하기
            let heightConstant = isAppearing ? keyboardHeight - 34 - 44 : 0
            
            UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                self.bottomConstraint.constant = heightConstant
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
            self.originalFullImage = image 
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
    
    func sendDateButtonTapped(_ date: Date) {
        print(date)
        popupBackground.animatePopupBackground(false)
        // date
    }
}
