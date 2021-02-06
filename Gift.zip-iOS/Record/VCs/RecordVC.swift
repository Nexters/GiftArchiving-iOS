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
    @IBOutlet weak var cropArea: UIView!
    @IBOutlet weak var emotionTextView: UITextView!
    @IBOutlet weak var bottomBarBottomConstraintWithBottomSafeArea: NSLayoutConstraint!
    @IBOutlet weak var upperContainerConstraintWithImageContainerTop: NSLayoutConstraint!
    
    @IBOutlet weak var bottomContainerHideAndShow: NSLayoutConstraint!
    @IBOutlet weak var emptyImageLabel: UILabel!
    
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var colorBottomContainer: UIView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var purposeImageView: UIImageView!
    @IBOutlet weak var emotionImageView: UIImageView!
    @IBOutlet weak var dateToRecordLabel: UILabel!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var frameButton: UIButton!
    @IBOutlet weak var stickerButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var dateDropDownImage: UIImageView!
    
    @IBOutlet var colorButtons: [UIButton]!
    
    @IBOutlet var backgroundColorViews: [UIView]!
    
    lazy var picker = UIImagePickerController()
    
    lazy var popupBackground = UIView()
    
    lazy var stickerPopupView = StickerView()
    
    lazy var exitButton = UIButton()
    
    private var textViewPlaceholderFlag: Bool = true
    
    private var originalFullImage: UIImage? // full Image
    
    var editedImage: UIImage? // cropped Image
    
    private var currentFrameOfImage: FrameOfImage = .square
    
    private var currentInfoViewOriginY: CGFloat = 0
    
    private var currentBottomContainerOriginY: CGFloat = 0
    
    private var currentImageContainerOriginY: CGFloat = 0
    
    private var stickerGroups: [UIImageView] = []
    
    private var categoryImageName: String = "icEtc"
    private var purposeImageName: String = "icEtc"
    private var emotionImageName: String = "icEtc"
    
    private var currentBackgroundPopupColor: UIColor = UIColor.Background.charcoalGrey.popup
    
    private var currentBackgroundColor: UIColor = UIColor.charcoalGrey {
        didSet {
            switch currentBackgroundColor {
            case .charcoalGrey:
                currentBackgroundPopupColor = UIColor.Background.charcoalGrey.popup
                break
            case .ceruleanBlue:
                currentBackgroundPopupColor = UIColor.Background.ceruleanBlue.popup
                break
            case .wheat:
                currentBackgroundPopupColor = UIColor.Background.wheat.popup
                break
            case .pinkishOrange:
                currentBackgroundPopupColor = UIColor.Background.pinkishOrange.popup
                break
            default:
                break
            }
            
            for changeView in backgroundColorViews {
                changeView.backgroundColor = currentBackgroundColor
            }
            
            if currentBackgroundColor == UIColor.wheat {
                backButton.setImage(UIImage.init(named: "iconBackBk"), for: .normal)
                dateToRecordLabel.textColor = .greyishBrown
                completeButton.setImage(UIImage.init(named: "iconCheckBk"), for: .normal)
                dateDropDownImage.image = UIImage.init(named: "iconArrowBottomBk")
                emptyImageLabel.textColor = .greyishBrown
                cropImageView.makeDashedBorder(UIColor.greyishBrown)
                fromLabel.textColor = .greyishBrown
                nameTextField.attributedPlaceholder = NSAttributedString(string: "이름",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 62.0 / 255.0, alpha: 0.34)])
                nameTextField.textColor = .greyishBrown
                categoryLabel.textColor = .greyishBrown
                purposeLabel.textColor = .greyishBrown
                emotionLabel.textColor = .greyishBrown
                
                categoryImageName = categoryImageName + "B"
                purposeImageName = purposeImageName + "B"
                emotionImageName = emotionImageName + "B"
                categoryImageView.image = UIImage(named: categoryImageName)
                purposeImageView.image = UIImage(named: purposeImageName)
                emotionImageView.image = UIImage(named: emotionImageName)
                
                emotionTextView.textColor = .greyishBrown

                
                let photo = UIImage(named: "iconCameraBk")
                let frame = UIImage(named: "iconShapeBk")
                let sticker = UIImage(named: "iconStickerBk")
                photoButton.setImage(photo, for: .normal)
                frameButton.setImage(frame, for: .normal)
                stickerButton.setImage(sticker, for: .normal)
                colorButton.layer.borderColor = UIColor.greyishBrown.cgColor
                
                for btn in colorButtons {
                    btn.layer.borderColor = UIColor.greyishBrown.cgColor
                }
                
                
            } else {
                backButton.setImage(UIImage.init(named: "iconBack"), for: .normal)
                dateToRecordLabel.textColor = .white
                completeButton.setImage(UIImage.init(named: "iconCheck"), for: .normal)
                dateDropDownImage.image = UIImage.init(named: "iconArrowBottom")
                emptyImageLabel.textColor = .white
                cropImageView.makeDashedBorder(UIColor.white)
                fromLabel.textColor = .white
                nameTextField.attributedPlaceholder = NSAttributedString(string: "이름",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.34)])
                nameTextField.textColor = .white
                categoryLabel.textColor = .white
                purposeLabel.textColor = .white
                emotionLabel.textColor = .white
                
                categoryImageName = categoryImageName.trimmingCharacters(in: ["B"])
                purposeImageName = purposeImageName.trimmingCharacters(in: ["B"])
                emotionImageName = emotionImageName.trimmingCharacters(in: ["B"])
                categoryImageView.image = UIImage(named: categoryImageName)
                purposeImageView.image = UIImage(named: purposeImageName)
                emotionImageView.image = UIImage(named: emotionImageName)
                emotionTextView.textColor = .white
                
                let photo = UIImage(named: "iconCamera")
                let frame = UIImage(named: "iconShape")
                let sticker = UIImage(named: "iconSticker")
                photoButton.setImage(photo, for: .normal)
                frameButton.setImage(frame, for: .normal)
                stickerButton.setImage(sticker, for: .normal)
                colorButton.layer.borderColor = UIColor.white.cgColor
                for btn in colorButtons {
                    btn.layer.borderColor = UIColor.white.cgColor
                }
            }
        }
    }
    
    private var isStickerEditing: Bool = false
    
    private var isSend: Bool = false
    
    private var dateToRecord: String = "" {
        didSet {
            dateToRecordLabel.text = dateToRecord
        }
    }
    
    private var isColorEditing: Bool = false {
        didSet {
            if isColorEditing {
                view.bringSubviewToFront(colorBottomContainer)
                view.bringSubviewToFront(exitButton)
                exitButton.isHidden = false
            } else {
                view.bringSubviewToFront(bottomContainer)
                exitButton.isHidden = true
            }
        }
    }
    
    
    let disposeBag = DisposeBag()
    
    private var isNameTouched: Bool = false
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let stickerButtonWidth = colorButton.frame.width
        colorButton.makeRounded(cornerRadius: stickerButtonWidth / 2)
        for button in colorButtons {
            let buttonWidth = button.frame.width
            button.makeRounded(cornerRadius: buttonWidth / 2)
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
        setNotificationCenter()
        initTextField()
        initializeDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("viewDidLayoutSubviews")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dateSegue" {
            popupBackground.animatePopupBackground(true)
            guard let des = segue.destination as? DatePopupVC else { return }
            des.delegate = self
            des.currentBackgroundColor = currentBackgroundColor
        } else if segue.identifier == "categoryPopup" {
            popupBackground.animatePopupBackground(true)
            view.bringSubviewToFront(categoryImageView)
            view.bringSubviewToFront(categoryLabel)
            guard let des = segue.destination as? IconPopupVC else { return }
            des.whichPopup = 0
            des.backgroundColor = currentBackgroundColor
            des.popupViewHeightByPhones = self.view.frame.height - infoView.frame.origin.y - 154
        } else if segue.identifier == "purposePopup" {
            popupBackground.animatePopupBackground(true)
            view.bringSubviewToFront(purposeImageView)
            view.bringSubviewToFront(purposeLabel)
            guard let des = segue.destination as? IconPopupVC else { return }
            des.whichPopup = 1
            des.backgroundColor = currentBackgroundColor
            des.popupViewHeightByPhones = self.view.frame.height - infoView.frame.origin.y - 154
        } else if segue.identifier == "emotionPopup" {
            popupBackground.animatePopupBackground(true)
            view.bringSubviewToFront(emotionImageView)
            view.bringSubviewToFront(emotionLabel)
            guard let des = segue.destination as? IconPopupVC else { return }
            des.whichPopup = 2
            des.backgroundColor = currentBackgroundColor
            des.isSend = self.isSend
            des.popupViewHeightByPhones = self.view.frame.height - infoView.frame.origin.y - 154
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func backToMain(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeRecord(_ sender: UIButton) {
        // record server
        
        let renderer = UIGraphicsImageRenderer(size: cropArea.bounds.size)
        let renderImage = renderer.image { _ in
             cropArea.drawHierarchy(in: cropArea.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(renderImage, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
//        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            print("saved cropped image")
        } else {
            print("error saving cropped image")
        }
    }
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "사진 선택", message: "선물을 골라주세요. 🎁", preferredStyle: .actionSheet)
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
        
    }
    
    @IBAction func useSticker(_ sender: UIButton) {
        if isStickerEditing {
            changeButtonContainerColor(false)
            changeStickerButtonInteraction(true)
            stickerPopupView.animateStickerView(false)
            makeButtonNormalOpacity()
            bottomContainer.backgroundColor = currentBackgroundColor
            isStickerEditing = false
        } else {
            changeButtonContainerColor(true)
            changeStickerButtonInteraction(false)
            stickerPopupView.outsideBackgroundColor = currentBackgroundColor
            stickerPopupView.animateStickerView(true)
            isStickerEditing = true
            makeButtonLowOpacity(index: 2)
            
        }
    }
    
    private func changeButtonContainerColor(_ direction: Bool) {
        if direction {
            UIView.animate(withDuration: 0.25) {
                self.bottomContainer.backgroundColor = self.currentBackgroundPopupColor
                self.view.backgroundColor = self.currentBackgroundPopupColor
            }
        } else {
            UIView.animate(withDuration: 0.10) {
                self.bottomContainer.backgroundColor = self.currentBackgroundColor
                self.view.backgroundColor = self.currentBackgroundColor
            }
        }
    }
    
    private func changeStickerButtonInteraction(_ direction: Bool) {
        photoButton.isUserInteractionEnabled = direction
        frameButton.isUserInteractionEnabled = direction
        colorButton.isUserInteractionEnabled = direction
    }
    
    private func makeButtonLowOpacity(index: Int) {
        photoButton.alpha = 0.3
        colorButton.alpha = 0.3
        if index == 1 {
            frameButton.alpha = 1.0
            stickerButton.alpha = 0.3
        } else if index == 2 {
            frameButton.alpha = 0.3
            stickerButton.alpha = 1.0
        }
    }
    
    private func makeButtonNormalOpacity() {
        photoButton.alpha = 1.0
        colorButton.alpha = 1.0
        frameButton.alpha = 1.0
        stickerButton.alpha = 1.0
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        if isColorEditing {
            isColorEditing = false
        } else {
            isColorEditing = true
        }
    }
    
    @IBAction func chanegToWheatColor(_ sender: UIButton) {
        currentBackgroundColor = .wheat
    }
    
    @IBAction func chanegToPinkishOrangeColor(_ sender: UIButton) {
        currentBackgroundColor = .pinkishOrange
    }
    @IBAction func changeToCeruleanBlueColor(_ sender: UIButton) {
        currentBackgroundColor = .ceruleanBlue
    }
    @IBAction func changeToCharcoalGreyColor(_ sender: UIButton) {
        currentBackgroundColor = .charcoalGrey
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
        cropImageView.makeDashedBorder(UIColor.white)
        
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        colorButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        colorButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        colorButton.layer.borderWidth = 1
        colorButton.layer.borderColor = UIColor.white.cgColor
        
        
        // 배경색 바꿀때 원래 메뉴로 돌아가는 버튼
        exitButton.addTarget(self, action: #selector(dismissColorBottomContainer), for: .touchUpInside)
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: colorBottomContainer.topAnchor).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        exitButton.isHidden = true
        
        // 스티커 뷰
        view.addSubview(stickerPopupView)
        stickerPopupView.translatesAutoresizingMaskIntoConstraints = false
        stickerPopupView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0).isActive = true
        stickerPopupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        stickerPopupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        stickerPopupView.topAnchor.constraint(equalTo: imageContainer
                                            .bottomAnchor, constant: 0).isActive = true
        stickerPopupView.alpha = 0
        stickerPopupView.isHidden = true
    }
    
    @objc func dismissColorBottomContainer() {
        isColorEditing = false
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectIcon), name: .init("selectIcon"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getStickerName), name: .init("getStickerName"), object: nil)
    }
    
    @objc private func getStickerName(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let stickerName = userInfo["stickerName"] as? String else { return }
        
        addStickerToCropView(stickerName)
    }
    
    private func addStickerToCropView(_ stickerName: String) {
        
        let sticker = UIImage.init(named: stickerName)!
        let singleStickerView = UIImageView(image: sticker)
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan)
        )
        let pinchGesture = UIPinchGestureRecognizer(
            target: self,
            action: #selector(handlePinch)
        )
        let rotateGesture = UIRotationGestureRecognizer(
            target: self,
            action: #selector(handleRotate)
        )
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress)
        )
        longPressGesture.minimumPressDuration = 0
        panGesture.delegate = self
        pinchGesture.delegate = self
        rotateGesture.delegate = self
        longPressGesture.delegate = self
        
        singleStickerView.addGestureRecognizer(panGesture)
        singleStickerView.addGestureRecognizer(pinchGesture)
        singleStickerView.addGestureRecognizer(rotateGesture)
        singleStickerView.addGestureRecognizer(longPressGesture)
        singleStickerView.isUserInteractionEnabled = true
        cropArea.addSubview(singleStickerView)
        stickerGroups.append(singleStickerView)
        
        singleStickerView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        singleStickerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func updateStickerFrame() {
        
    }
    
    @objc func handleLongPress() {
        
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {

        print("PAN")
        let translation = gesture.translation(in: view)
        
        guard let gestureView = gesture.view as? UIImageView else {
            return
        }
        
        gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )
        gesture.setTranslation(.zero, in: view)
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        
        
        guard let gestureView = gesture.view as? UIImageView else {
            return
        }
        
        gestureView.transform = gestureView.transform.scaledBy(
            x: gesture.scale,
            y: gesture.scale
        )
        gesture.scale = 1
        
//        if gesture.state == .ended {
//            self.selectedSticker = nil
//        }
    }
    
    
    @objc func handleRotate(_ gesture: UIRotationGestureRecognizer) {
        
        guard let gestureView = gesture.view as? UIImageView else {
            return
        }
        
        gestureView.transform = gestureView.transform.rotated(
            by: gesture.rotation
        )
        gesture.rotation = 0
        
//        if gesture.state == .ended {
//            self.selectedSticker = nil
//        }
    }
    
    
    
    @objc private func selectIcon(_ notification: Notification) {
        
        popupBackground.animatePopupBackground(false)
        view.bringSubviewToFront(bottomContainer)
        view.bringSubviewToFront(popupBackground)
        
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let iconImage = userInfo["iconImageName"] as? String else { return }
        guard let iconName = userInfo["iconName"] as? String else { return }
        guard let iconKind = userInfo["iconKind"] as? String else { return }
        
        if iconKind == "category" {
            categoryImageView.image = UIImage(named: iconImage)
            categoryLabel.text = iconName
            categoryImageName = iconImage
        } else if iconKind == "purpose" {
            purposeImageView.image = UIImage(named: iconImage)
            purposeLabel.text = iconName
            purposeImageName = iconImage
        } else {
            emotionImageView.image = UIImage(named: iconImage)
            emotionLabel.text = iconName
            emotionImageName = iconImage
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

            self.bottomBarBottomConstraintWithBottomSafeArea.constant = heightConstant
            isNameTouched = false
            self.view.layoutIfNeeded()

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

extension RecordVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UILongPressGestureRecognizer {
            if let v = gestureRecognizer.view {
                v.superview?.bringSubviewToFront(v)
            }
        }
        return true
    }
}
