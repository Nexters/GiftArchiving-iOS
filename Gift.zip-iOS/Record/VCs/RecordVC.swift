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
    case full
}

class RecordVC: UIViewController {
    
    @IBOutlet weak var editCancelButton: UIButton!
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
    
    @IBOutlet weak var bottomContainerConstarintWhenNameTextFieldTouched: NSLayoutConstraint!
    @IBOutlet var colorButtons: [UIButton]!
    
    
    // Frame관련 IBOutlets
    @IBOutlet weak var changeFrameView: UIView!
    @IBOutlet weak var squareFrameView: UIView!
    @IBOutlet weak var circleFrameView: UIView!
    @IBOutlet weak var windowFrameView: UIView!
    @IBOutlet weak var fullFrameView: UIView!
    @IBOutlet weak var squareViewLabel: UILabel!
    @IBOutlet weak var circleViewLabel: UILabel!
    @IBOutlet weak var windowViewLabel: UILabel!
    @IBOutlet weak var fullViewLabel: UILabel!
    
    @IBOutlet var backgroundColorViews: [UIView]!
    
    // image Crop 할 때 바꾸기
    @IBOutlet weak var rectagularInstagramCropView: UIView!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    
    // kakaoImageEnvelop
    @IBOutlet weak var imageViewAfterstickerCropped: UIImageView!
    @IBOutlet weak var logoSticker: UIImageView!
    @IBOutlet weak var nameEnvelopLabel: UILabel!
    @IBOutlet weak var kakaoShareImageView: UIView!
    @IBOutlet weak var kakaoShareView: UIView!
    
    
    lazy var picker = UIImagePickerController()
    
    lazy var popupBackground = UIView()
    
    lazy var stickerPopupView = StickerPopupView()
    
    lazy var exitColorEditButton = UIButton()
    
    lazy var exitFrameEditButton = UIButton()
    
    var isReceiveGift: Bool = true
    
    private var isTappedAlready: Bool = false
    
    private var textViewPlaceholderFlag: Bool = true
    
    private var originalFullImage: UIImage? // full Image
    
    private var _selectedStickerView:StickerView?
    
    private var frameType: String = "SQUARE"
    
    var isGiftEditing: Bool = false
    var editFrameType: String?
    var editCurrentColor: String?
    var editNoBgImageURL: String?
    var editBgImageURL: String?
    var editCategoryImageName: String?
    var editPurposeImageName: String?
    var editEmotionImageName: String?
    var editContent: String?
    var editCategoryName: String?
    var editPurposeName: String?
    var editEmotionName: String?
    var editCurrentDate: String?
    var editName: String?
    var editIsReceiveGift: Bool?
    var editGiftId: String?
    var editReceiveDate: String?
    var isDateChanged: Bool = false
    @IBOutlet weak var editImageView: UIImageView!
    
    var selectedStickerView:StickerView? {
        get {
            return _selectedStickerView
        }
        set {
            // if other sticker choosed then resign the handler
            if _selectedStickerView != newValue {
                if let selectedStickerView = _selectedStickerView {
                    selectedStickerView.showEditingHandlers = false
                }
                _selectedStickerView = newValue
            }
            // assign handler to new sticker added
            if let selectedStickerView = _selectedStickerView {
                selectedStickerView.showEditingHandlers = true
                selectedStickerView.superview?.bringSubviewToFront(selectedStickerView)
            }
        }
    }
    
    var editedImage: UIImage? // cropped Image
    
    private var currentFrameOfImage: FrameOfImage = .square {
        didSet {
            if !isImageSelected {
                switch currentFrameOfImage {
                case .square:
                    cropImageView.image = UIImage.init(named: "dotRectangle")
                    break
                case .circle:
                    cropImageView.image = UIImage.init(named: "dotCircle")
                    break
                case .windowFrame:
                    cropImageView.image = UIImage.init(named: "dotWindow")
                    break
                case .full:
                    cropImageView.image = UIImage.init(named: "dotRectangle")
                    break
                }
            }
            
            switch currentFrameOfImage {
            case .square:
                frameType = "SQUARE"
                logoSticker.makeRounded(cornerRadius: 0)
                break
            case .circle:
                frameType = "CIRCLE"
                let radius = logoSticker.bounds.width / 2
                logoSticker.makeRounded(cornerRadius: radius)
                break
            case .full:
                frameType = "SQUARE"
                logoSticker.makeRounded(cornerRadius: 0)
                break
            case .windowFrame:
                frameType = "ARCH"
                let radius = logoSticker.bounds.width / 2
                logoSticker.roundCorners(cornerRadius: radius, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
                break
            }
            
            let radius = cropImageView.frame.width / 2
            switch currentFrameOfImage {
            case .full:
                fullFrameView.alpha = 1.0
                squareFrameView.alpha = 0.6
                circleFrameView.alpha = 0.6
                windowFrameView.alpha = 0.6
                
                fullViewLabel.alpha = 1.0
                squareViewLabel.alpha = 0.6
                circleViewLabel.alpha = 0.6
                windowViewLabel.alpha = 0.6
                
                cropImageView.makeRounded(cornerRadius: 0)
                
                break
            case .square:
                fullFrameView.alpha = 0.6
                squareFrameView.alpha = 1.0
                circleFrameView.alpha = 0.6
                windowFrameView.alpha = 0.6
                
                
                fullViewLabel.alpha = 0.6
                squareViewLabel.alpha = 1.0
                circleViewLabel.alpha = 0.6
                windowViewLabel.alpha = 0.6
                
                cropImageView.makeRounded(cornerRadius: 0)
                print("square")
                break
            case .circle:
                fullFrameView.alpha = 0.6
                squareFrameView.alpha = 0.6
                circleFrameView.alpha = 1.0
                windowFrameView.alpha = 0.6
                
                
                fullViewLabel.alpha = 0.6
                squareViewLabel.alpha = 0.6
                circleViewLabel.alpha = 1.0
                windowViewLabel.alpha = 0.6
                
                cropImageView.roundCorners(cornerRadius: radius, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
                print("circle")
                break
                
            case .windowFrame:
                fullFrameView.alpha = 0.6
                squareFrameView.alpha = 0.6
                circleFrameView.alpha = 0.6
                windowFrameView.alpha = 1.0
                
                
                fullViewLabel.alpha = 0.6
                squareViewLabel.alpha = 0.6
                circleViewLabel.alpha = 0.6
                windowViewLabel.alpha = 1.0
                
                cropImageView.roundCorners(cornerRadius: radius, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
                print("windowFrame")
                break
            }
        }
    }
    
    private var currentInfoViewOriginY: CGFloat = 0
    
    private var currentBottomContainerOriginY: CGFloat = 0
    
    private var currentImageContainerOriginY: CGFloat = 0
    
    private var stickerGroups: [UIImageView] = []
    
    private var categoryImageName: String = "iconCategoryDefault"
    private var purposeImageName: String = "iconPurposeDefault"
    private var emotionImageName: String = "iconFeelingDefault"
    
    private var isImageSelected: Bool = false
    private var isNameTyped: Bool = false
    private var isCategoryIconSelected: Bool = false
    private var isPurposeIconSelected: Bool = false
    private var isEmotionIconSelected: Bool = false
    
    private var currentBackgroundPopupColor: UIColor = UIColor.Background.charcoalGrey.popup
    
    private var currentBackgroundColorString: String = "charcoalGrey"
    private var currentBackgroundColor: UIColor = UIColor.charcoalGrey {
        didSet {
            let image = UIImage.init(named: "iconCancelBk")
            editCancelButton.setImage(image, for: .normal)
            selectedStickerView?.currentBackgroundColor = currentBackgroundColor
            switch currentBackgroundColor {
            case .charcoalGrey:
                imageContainer.backgroundColor = .charcoalGrey
                currentBackgroundColorString = "charcoalGrey"
                currentBackgroundPopupColor = UIColor.Background.charcoalGrey.popup
                break
            case .ceruleanBlue:
                imageContainer.backgroundColor = .ceruleanBlue
                currentBackgroundColorString = "ceruleanBlue"
                currentBackgroundPopupColor = UIColor.Background.ceruleanBlue.popup
                break
            case .wheat:
                imageContainer.backgroundColor = .wheat
                currentBackgroundColorString = "wheat"
                currentBackgroundPopupColor = UIColor.Background.wheat.popup
                break
            case .pinkishOrange:
                imageContainer.backgroundColor = .pinkishOrange
                currentBackgroundColorString = "pinkishOrange"
                currentBackgroundPopupColor = UIColor.Background.pinkishOrange.popup
                break
            default:
                break
            }
            
            for changeView in backgroundColorViews {
                changeView.backgroundColor = currentBackgroundColor
            }
            
            if currentBackgroundColor == UIColor.wheat {
                nameEnvelopLabel.textColor = .black
                logoSticker.image = UIImage.init(named: "logoBgcolorNoneBlack")
                backButton.setImage(UIImage.init(named: "iconBackBk"), for: .normal)
                dateToRecordLabel.textColor = .greyishBrown
                completeButton.setImage(UIImage.init(named: "iconCheckBk"), for: .normal)
                dateDropDownImage.image = UIImage.init(named: "iconArrowBottomBk")
                emptyImageLabel.textColor = .greyishBrown
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
                nameEnvelopLabel.textColor = .white
                logoSticker.image = UIImage.init(named: "logoBgcolorNoneWhite")
                backButton.setImage(UIImage.init(named: "iconBack"), for: .normal)
                dateToRecordLabel.textColor = .white
                completeButton.setImage(UIImage.init(named: "iconCheck"), for: .normal)
                dateDropDownImage.image = UIImage.init(named: "iconArrowBottom")
                emptyImageLabel.textColor = .white
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
    
    private var selectedDate: Date = Date()
    
    private var isStickerEditing: Bool = false
    private var isStickerGuideLineEditing: Bool = false
    
    private var isFrameEditing: Bool = false {
        didSet {
            if isFrameEditing {
                changeButtonContainerColor(true)
                changeFrameButtonInteraction(false)
                animateFrameView(true)
                changeFrameView.backgroundColor = currentBackgroundPopupColor
                makeButtonLowOpacity(index: 1)
                exitFrameEditButton.isHidden = false
            } else {
                view.bringSubviewToFront(exitFrameEditButton)
                changeButtonContainerColor(false)
                changeFrameButtonInteraction(true)
                animateFrameView(false)
                makeButtonNormalOpacity()
                exitFrameEditButton.isHidden = true
            }
        }
    }
    
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
                view.bringSubviewToFront(exitColorEditButton)
                colorBottomContainer.alpha = 1
                colorBottomContainer.isHidden = false
                exitColorEditButton.isHidden = false
            } else {
                view.bringSubviewToFront(bottomContainer)
                colorBottomContainer.alpha = 0
                colorBottomContainer.isHidden = true
                exitColorEditButton.isHidden = true
            }
        }
    }
    
    
    let disposeBag = DisposeBag()
    
    private var isNameTouched: Bool = false
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let stickerButtonWidth = colorButton.frame.width
        colorButton.makeRounded(cornerRadius: stickerButtonWidth / 2)
        for button in colorButtons {
            let buttonWidth = button.frame.width
            button.makeRounded(cornerRadius: buttonWidth / 2)
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 1
        }
        
        fromLabel.text = isReceiveGift ? "From." : "To."
        
        if isGiftEditing {
            
            if editCurrentColor! == "wheat" {
                currentBackgroundColor = UIColor.wheat
                editCategoryImageName = editCategoryImageName?.trimmingCharacters(in: ["B"])
                editPurposeImageName = editPurposeImageName?.trimmingCharacters(in: ["B"])
                editEmotionImageName = editEmotionImageName?.trimmingCharacters(in: ["B"])
            } else if editCurrentColor! == "ceruleanBlue" {
                currentBackgroundColor = UIColor.ceruleanBlue
            } else if editCurrentColor! == "charcoalGrey" {
                currentBackgroundColor = UIColor.charcoalGrey
            } else {
                currentBackgroundColor = UIColor.pinkishOrange
            }
            
            categoryImageName = editCategoryImageName!
            categoryLabel.text = editCategoryName!
            isCategoryIconSelected = true
            purposeImageName = editPurposeImageName!
            purposeLabel.text = editPurposeName!
            isPurposeIconSelected = true
            emotionImageName = editEmotionImageName!
            emotionLabel.text = editEmotionName!
            isEmotionIconSelected = true
            nameTextField.text = editName
            
            
            fromLabel.text = editIsReceiveGift! ? "From." : "To."
            fromLabel.alpha = 1
            
            emotionTextView.text = editContent!
            if emotionTextView.text == "" || emotionTextView.text == nil {
                textViewPlaceholderFlag = true
            } else {
                textViewPlaceholderFlag = false
            }
            if textViewPlaceholderFlag {
                emotionTextView.text = "지금 이 감정을 기록해보세요."
                emotionTextView.alpha = 0.34
            } else {
                emotionTextView.alpha = 1.0
            }
            
            
            emptyImageLabel.isHidden = true
            
         
            
            let url = URL(string: editNoBgImageURL!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)
            editImageView.isHidden = false
            editImageView.kf.setImage(with: url)
            
            editCancelButton.isHidden = false

            backButton.isHidden = true
            
            dateToRecord = self.editCurrentDate ?? ""
            
            
            
            nameTextField.isUserInteractionEnabled = false
            photoButton.isHidden = true
            frameButton.isHidden = true
            stickerButton.isHidden = true
            colorButton.isHidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
        setNotificationCenter()
        initTextField()
        initializeDelegates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.view.endEditing(true)
        if segue.identifier == "dateSegue" {
            //            popupBackground.animatePopupBackground(true)
            guard let des = segue.destination as? DatePopupVC else { return }
            des.delegate = self
            des.currentBackgroundColor = currentBackgroundPopupColor
        } else if segue.identifier == "categoryPopup" {
            popupBackground.animatePopupBackground(true)
            view.bringSubviewToFront(categoryImageView)
            view.bringSubviewToFront(categoryLabel)
            guard let des = segue.destination as? IconPopupVC else { return }
            des.whichPopup = 0
            des.backgroundColor = currentBackgroundColor
            des.popupViewHeightByPhones = self.view.frame.height - infoView.frame.origin.y - 173
        } else if segue.identifier == "purposePopup" {
            popupBackground.animatePopupBackground(true)
            view.bringSubviewToFront(purposeImageView)
            view.bringSubviewToFront(purposeLabel)
            guard let des = segue.destination as? IconPopupVC else { return }
            des.whichPopup = 1
            des.backgroundColor = currentBackgroundColor
            des.popupViewHeightByPhones = self.view.frame.height - infoView.frame.origin.y - 173
        } else if segue.identifier == "emotionPopup" {
            popupBackground.animatePopupBackground(true)
            view.bringSubviewToFront(emotionImageView)
            view.bringSubviewToFront(emotionLabel)
            guard let des = segue.destination as? IconPopupVC else { return }
            des.whichPopup = 2
            des.backgroundColor = currentBackgroundColor
            des.isReceiveGift = isReceiveGift
            des.popupViewHeightByPhones = self.view.frame.height - infoView.frame.origin.y - 173
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func backToEdit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToMain(_ sender: UIButton) {
        
        if isImageSelected || isNameTyped || isCategoryIconSelected || isPurposeIconSelected || isEmotionIconSelected
            || emotionTextView.text != "지금 이 감정을 기록해보세요." {
            guard let vc = self.storyboard?.instantiateViewController(identifier: "WarningOutVC") as? WarningOutVC else { return }
            
            vc.modalPresentationStyle = .overFullScreen
            popupBackground.animatePopupBackground(true)
            self.present(vc, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

    @IBAction func completeRecord(_ sender: UIButton) {
        
        // record server
        if isGiftEditing {
            if isGiftEditing {
                // 통신
                if !emotionTextView.text.isEmpty || emotionTextView.text != "지금 이 감정을 기록해보세요." {
                    
                    let content: String = emotionTextView.text
                    
                    
                    // 날짜
                    var date: String = ""
                    if isDateChanged {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                        let dateString = dateFormatter.string(from: selectedDate)
                        print(dateString)
                        let dateArr = dateString.components(separatedBy: [" "," "])
                        let first = dateArr[0]
                        let second = dateArr[1]
                        print(dateArr[2])
                        date = first + "T" + second
                    } else {
                        date = self.editReceiveDate ?? ""
                    }
                    
                    
                    
                    var category: String = ""
                    var emotion: String = ""
                    var reason: String = ""
                    for c in Icons.category {
                        if categoryLabel.text == c.name {
                            category = c.englishName
                        }
                    }
                    
                    if editIsReceiveGift! {
                        for e in Icons.emotionGet {
                            if emotionLabel.text == e.name {
                                emotion = e.englishName
                            }
                        }
                    } else {
                        for e in Icons.emotionSend {
                            if emotionLabel.text == e.name {
                                emotion = e.englishName
                            }
                        }
                    }
                    for p in Icons.purpose {
                        if purposeLabel.text == p.name {
                            reason = p.englishName
                        }
                    }

                    GiftService.shared.putGift(category: category, content: content, emotion: emotion, reason: reason, receiveDate: date, giftId: editGiftId!)  { networkResult -> Void in
                        switch networkResult {
                        case .success:
                            print("ㄷ ㄷ")
                        case .requestErr:
                            let alertViewController = UIAlertController(title: "통신 실패", message: "💩", preferredStyle: .alert)
                            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                            alertViewController.addAction(action)
                            self.present(alertViewController, animated: true, completion: nil)
                            
                        case .pathErr: print("path")
                        case .serverErr:
                            let alertViewController = UIAlertController(title: "통신 실패", message: "서버 오류", preferredStyle: .alert)
                            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                            alertViewController.addAction(action)
                            self.present(alertViewController, animated: true, completion: nil)
                            print("networkFail")
                            print("serverErr")
                        case .networkFail:
                            let data = ["content" : content]
                            NotificationCenter.default.post(name: .init("broadcastUpdate"), object: nil, userInfo: data)
                        }
                    }
                } else {
                    let alertViewController = UIAlertController(title: "저장 실패", message: "내용을 입력해주세요. 🥰", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                    alertViewController.addAction(action)
                    self.present(alertViewController, animated: true, completion: nil)
                }
                
            }
            return
        }
        selectedStickerView?.showEditingHandlers = false
        if isImageSelected {
            if isNameTyped {
                if isCategoryIconSelected && isPurposeIconSelected && isEmotionIconSelected {
                    if emotionTextView.text != "지금 이 감정을 기록해보세요." {
                        if isTappedAlready == false {
                            isTappedAlready = true
                            
                            kakaoShareImageView.isHidden = false
                            // 공유할 게시할 이미지 넘기기 작업
                            let noBackgroundCropped = UIGraphicsImageRenderer(size: cropArea.bounds.size)
                            cropArea.backgroundColor = UIColor.clear
                            let noBackgroundCroppedImage = noBackgroundCropped.image { _ in
                                cropArea.drawHierarchy(in: cropArea.bounds, afterScreenUpdates: true)
                            }
                            let noBackgroundImageView = UIImageView.init(image: noBackgroundCroppedImage)
                            rectagularInstagramCropView.addSubview(noBackgroundImageView)
                            noBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
                            noBackgroundImageView.leadingAnchor.constraint(equalTo: rectagularInstagramCropView.leadingAnchor, constant: 0).isActive = true
                            noBackgroundImageView.trailingAnchor.constraint(equalTo: rectagularInstagramCropView.trailingAnchor, constant: 0).isActive = true
                            noBackgroundImageView.contentMode = .scaleAspectFit
                            noBackgroundImageView.centerXAnchor.constraint(equalTo: rectagularInstagramCropView.centerXAnchor).isActive = true
                            noBackgroundImageView.centerYAnchor.constraint(equalTo: rectagularInstagramCropView.centerYAnchor, constant: 0).isActive = true
                            let noBackgroundSquare = UIGraphicsImageRenderer(size: rectagularInstagramCropView.bounds.size)
                            let noBackgroundSquareImage = noBackgroundSquare.image { _ in
                                rectagularInstagramCropView.drawHierarchy(in: rectagularInstagramCropView.bounds, afterScreenUpdates: true)
                            }
                            
                            // 편지봉투 카카오톡 공유하기에 들어갈 이미지
                            imageViewAfterstickerCropped.image = noBackgroundSquareImage
                            nameEnvelopLabel.text = "\(fromLabel.text!) \(nameTextField.text!)"
                            nameEnvelopLabel.textColor = currentBackgroundColor == UIColor.wheat ? .black : .white
                            kakaoShareView.backgroundColor = currentBackgroundColor
                            imageViewAfterstickerCropped.backgroundColor = currentBackgroundColor
                            logoSticker.backgroundColor = currentBackgroundColor
                            
                            let kakaoImage = UIGraphicsImageRenderer(size: kakaoShareImageView.bounds.size)
                            let kakaoEnvelopImage = kakaoImage.image { _ in
                                kakaoShareImageView.drawHierarchy(in: kakaoShareImageView.bounds, afterScreenUpdates: true)
                            }
                            
                            nameEnvelopLabel.isHidden = true
                            
                            // 인스타그램 공유하기에 들어갈 이미지
                            noBackgroundImageView.leadingAnchor.constraint(equalTo: rectagularInstagramCropView.leadingAnchor, constant: 10).isActive = true
                            noBackgroundImageView.trailingAnchor.constraint(equalTo: rectagularInstagramCropView.trailingAnchor, constant: 10).isActive = true
                            noBackgroundImageView.centerXAnchor.constraint(equalTo: rectagularInstagramCropView.centerXAnchor).isActive = true
                            noBackgroundImageView.topAnchor.constraint(equalTo: rectagularInstagramCropView.topAnchor, constant: 20).isActive = true
                            noBackgroundImageView.bottomAnchor.constraint(equalTo: rectagularInstagramCropView.bottomAnchor, constant: -50).isActive = true
                            noBackgroundImageView.contentMode = .scaleAspectFit
                            
                            let label = UILabel()
                            label.text = fromLabel.text! + nameTextField.text!
                            label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 16)
                            label.textColor = currentBackgroundColor == UIColor.wheat ? .black : .white
                            
                            rectagularInstagramCropView.addSubview(label)
                            label.translatesAutoresizingMaskIntoConstraints = false
                            
                            let constraint: CGFloat = (rectagularInstagramCropView.frame.height - noBackgroundImageView.frame.height - 20) / 2
                            label.topAnchor.constraint(equalTo: noBackgroundImageView.bottomAnchor, constant: constraint).isActive = true
                            label.centerXAnchor.constraint(equalTo: rectagularInstagramCropView.centerXAnchor).isActive = true
                            
                            rectagularInstagramCropView.backgroundColor = currentBackgroundColor
                            let myPhone = UIGraphicsImageRenderer(size: rectagularInstagramCropView.bounds.size)
                            let myPhonePhoto = myPhone.image { _ in
                                rectagularInstagramCropView.drawHierarchy(in: rectagularInstagramCropView.bounds, afterScreenUpdates: true)
                            }
                            
                            rectagularInstagramCropView.makeRounded(cornerRadius: 8.0)
                            let instagram = UIGraphicsImageRenderer(size: rectagularInstagramCropView.bounds.size)
                            let instagramSquareImage = instagram.image { _ in
                                rectagularInstagramCropView.drawHierarchy(in: rectagularInstagramCropView.bounds, afterScreenUpdates: true)
                            }
                            
                            guard let share = UIStoryboard.init(name: "Share", bundle: nil).instantiateViewController(identifier: "ShareVC") as? ShareVC else { return }
                            
                            share.currentName = "\(fromLabel.text!) \(nameTextField.text!)"
                            share.currentBackgroundColor = currentBackgroundColor
                            share.envelopImage = noBackgroundSquareImage
                            share.instagramImage = instagramSquareImage
                            // instagramSquareImage
                            share.myPhonePhoto = myPhonePhoto
                            // myPhonePhoto
                            share.currentFrameOfImage = currentFrameOfImage
                            share.userName = nameTextField.text
                            
                            let content = emotionTextView.text ?? ""
                            let name = nameTextField.text ?? ""
                            
                            // 날짜
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                            let dateString = dateFormatter.string(from: selectedDate)
                            print(dateString)
                            let dateArr = dateString.components(separatedBy: [" "," "])
                            let first = dateArr[0]
                            let second = dateArr[1]
                            print(dateArr[2])
                            let date = first + "T" + second
                            // 아이콘 이름
                            
                            var categoryName: String = ""
                            var purposeName: String = ""
                            var emotionName: String = ""
                            if currentBackgroundColor == UIColor.wheat {
                                categoryImageName = categoryImageName.trimmingCharacters(in: ["B"])
                                purposeImageName = purposeImageName.trimmingCharacters(in: ["B"])
                                emotionImageName = emotionImageName.trimmingCharacters(in: ["B"])
                            }
                            
                            for category in Icons.category {
                                if category.imageName == categoryImageName {
                                    categoryName = category.englishName
                                }
                            }
                            
                            for purpose in Icons.purpose {
                                if purpose.imageName == purposeImageName {
                                    purposeName = purpose.englishName
                                }
                            }
                            
                            if isReceiveGift {
                                for emotion in Icons.emotionGet {
                                    if emotion.imageName == emotionImageName {
                                        emotionName = emotion.englishName
                                    }
                                }
                            } else {
                                for emotion in Icons.emotionSend {
                                    if emotion.imageName == emotionImageName {
                                        emotionName = emotion.englishName
                                    }
                                }
                            }
                            var token: String = ""
                            let SPREF = UserDefaults.standard
                            if let appleId = SPREF.string(forKey: "appleId"){
                                token = appleId
                            } else {
                                if let kakaoId = SPREF.string(forKey: "kakaoId") {
                                    token = kakaoId
                                }
                            }
                            
                            let bgImg = resizeImage(image: kakaoEnvelopImage, newWidth: kakaoEnvelopImage.size.width)
                            let noBgImg = resizeImage(image: noBackgroundSquareImage, newWidth: noBackgroundSquareImage.size.width)
                            
                            GiftService.shared.recordGift(content: content, isReceiveGift: isReceiveGift, name: name, receiveDate: date, createdBy: token, category: categoryName, emotion: emotionName, reason: purposeName, bgColor: currentBackgroundColorString, bgImg: bgImg!, noBgImg: noBgImg!, frameType: frameType) { networkResult -> Void in
                                switch networkResult {
                                case .success(let data):
                                    if let bgData = data as? RecordGiftData {
                                        print(bgData)
                                        self.broadcastAdd(gift: ["gifts" : [["id": bgData.id, "imgUrl" : bgData.noBgImg, "name": name, "content" : content , "receiveDate" : date, "bgColor" : self.currentBackgroundColorString, "isReceiveGift" : String(self.isReceiveGift), "category" : categoryName, "emotion": emotionName, "reason" : purposeName, "frameType": self.frameType]]], isReceive: self.isReceiveGift)
                                        share.kakaoImageURL = bgData.bgImg
                                        self.navigationController?.pushViewController(share, animated: true)
                                    }
                                    
                                    
                                    
                                    
                                case .requestErr:
                                    let alertViewController = UIAlertController(title: "통신 실패", message: "💩", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                                    alertViewController.addAction(action)
                                    self.present(alertViewController, animated: true, completion: nil)
                                    
                                case .pathErr: print("path")
                                case .serverErr:
                                    let alertViewController = UIAlertController(title: "통신 실패", message: "서버 오류", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                                    alertViewController.addAction(action)
                                    self.present(alertViewController, animated: true, completion: nil)
                                    print("networkFail")
                                    print("serverErr")
                                case .networkFail:
                                    let alertViewController = UIAlertController(title: "통신 실패", message: "네트워크 오류", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                                    alertViewController.addAction(action)
                                    self.present(alertViewController, animated: true, completion: nil)
                                    print("networkFail")
                                }
                            }
                        }
                        
                    } else {
                        let alertViewController = UIAlertController(title: "저장 실패", message: "내용을 입력해주세요. 🥰", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                        alertViewController.addAction(action)
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                } else {
                    
                    let alertViewController = UIAlertController(title: "저장 실패", message: "선물에 해당하는 아이콘을 선택해주세요 🥰", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                    alertViewController.addAction(action)
                    self.present(alertViewController, animated: true, completion: nil)
                }
            } else {
                
                let alertViewController = UIAlertController(title: "저장 실패", message: "이름을 입력해주세요 🥰", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertViewController.addAction(action)
                self.present(alertViewController, animated: true, completion: nil)
            }
        } else {
            
            let alertViewController = UIAlertController(title: "저장 실패", message: "이미지를 선택해주세요 🥰", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
        }
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        self.view.endEditing(true)
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
        self.view.endEditing(true)
        if isFrameEditing {
            print("button false")
            isFrameEditing = false
        } else {
            print("button true")
            isFrameEditing = true
        }
    }
    
    @IBAction func useSticker(_ sender: UIButton) {
        self.view.endEditing(true)
        if isStickerEditing {
            isStickerEditing = false
            changeButtonContainerColor(false)
            changeStickerButtonInteraction(true)
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction,.curveLinear], animations: {
                self.stickerPopupView.frame.origin.y += 700
                
            }, completion: { _ in
                self.stickerPopupView.animateStickerView(false)
                self.stickerPopupView.frame.origin.y -= 700
            })
            makeButtonNormalOpacity()
            bottomContainer.backgroundColor = currentBackgroundColor
        } else {
            isStickerEditing = true
            changeButtonContainerColor(true)
            changeStickerButtonInteraction(false)
            stickerPopupView.outsideBackgroundColor = currentBackgroundColor
            stickerPopupView.animateStickerView(true)
            makeButtonLowOpacity(index: 2)
            
        }
    }
    
    private func animateFrameView(_ direction: Bool) {
        changeFrameView.isHidden = !direction
        let alpha: CGFloat = direction ? 1.0 : 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.changeFrameView.alpha = alpha
        }, completion: nil)
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
    
    private func changeFrameButtonInteraction(_ direction: Bool) {
        photoButton.isUserInteractionEnabled = direction
        stickerButton.isUserInteractionEnabled = direction
        colorButton.isUserInteractionEnabled = direction
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
        self.view.endEditing(true)
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
    
    @IBAction func changeToSquareFrame(_ sender: UIButton) {
        currentFrameOfImage = .square
    }
    @IBAction func changeToCircleFrame(_ sender: UIButton) {
        currentFrameOfImage = .circle
    }
    @IBAction func changeToWindowFrame(_ sender: UIButton) {
        currentFrameOfImage = .windowFrame
    }
    @IBAction func changeToFullFrame(_ sender: UIButton) {
        currentFrameOfImage = .full
        
    }
    
}

//MARK: - Private Methods

extension RecordVC {
    
    private func setLayouts() {
        colorBottomContainer.alpha = 0
        colorBottomContainer.isHidden = true
        for button in buttons {
            button.makeRounded(cornerRadius: 8.0)
        }
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "이름",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(white: 1.0, alpha: 0.34)]
        )
        popupBackground.setPopupBackgroundView(to: view)
        emotionTextView.textColor = UIColor.white
        if emotionTextView.text == "" || emotionTextView.text == nil {
            textViewPlaceholderFlag = true
        } else {
            textViewPlaceholderFlag = false
        }
        if textViewPlaceholderFlag {
            emotionTextView.text = "지금 이 감정을 기록해보세요."
            emotionTextView.alpha = 0.34
        } else {
            emotionTextView.alpha = 1.0
        }
        
        
        
        categoryImageView.image = UIImage(named: categoryImageName)
        purposeImageView.image = UIImage(named: purposeImageName)
        emotionImageView.image = UIImage(named: emotionImageName)
        
        
        
        
        
        
        currentInfoViewOriginY = infoView.frame.origin.y
        currentBottomContainerOriginY = bottomContainer.frame.origin.y
        currentImageContainerOriginY = imageContainer.frame.origin.y
        
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        colorButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        colorButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        colorButton.layer.borderWidth = 1
        colorButton.layer.borderColor = UIColor.white.cgColor
        
        
        // 배경색 바꿀 때 원래 메뉴로 돌아가는 버튼
        exitColorEditButton.addTarget(self, action: #selector(dismissColorBottomContainer), for: .touchUpInside)
        view.addSubview(exitColorEditButton)
        exitColorEditButton.translatesAutoresizingMaskIntoConstraints = false
        exitColorEditButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        exitColorEditButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        exitColorEditButton.bottomAnchor.constraint(equalTo: colorBottomContainer.topAnchor).isActive = true
        exitColorEditButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        exitColorEditButton.isHidden = true
        
        // 프레임 바꿀 때 원래 메뉴로 돌아가는 버튼
        exitFrameEditButton.addTarget(self, action: #selector(dismissFrameButton), for: .touchUpInside)
        view.addSubview(exitFrameEditButton)
        exitFrameEditButton.translatesAutoresizingMaskIntoConstraints = false
        exitFrameEditButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        exitFrameEditButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        exitFrameEditButton.bottomAnchor.constraint(equalTo: changeFrameView.topAnchor).isActive = true
        exitFrameEditButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        exitFrameEditButton.isHidden = true
        
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
        
        squareFrameView.layer.borderWidth = 2
        squareFrameView.layer.borderColor = UIColor.white.cgColor
        squareFrameView.alpha = 1.0
        
        circleFrameView.layer.borderWidth = 2
        circleFrameView.layer.borderColor = UIColor.white.cgColor
        circleFrameView.alpha = 0.6
        let circleRadius = circleFrameView.frame.width / 2
        circleFrameView.makeRounded(cornerRadius: circleRadius)
        
        windowFrameView.layer.borderWidth = 2
        windowFrameView.layer.borderColor = UIColor.white.cgColor
        windowFrameView.alpha = 0.6
        let windowRadius = windowFrameView.frame.width / 2
        windowFrameView.roundCorners(cornerRadius: windowRadius, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        
        fullFrameView.layer.borderWidth = 2
        fullFrameView.layer.borderColor = UIColor.white.cgColor
        fullFrameView.alpha = 0.6
        
        fullViewLabel.alpha = 0.6
        squareViewLabel.alpha = 1.0
        circleViewLabel.alpha = 0.6
        windowViewLabel.alpha = 0.6
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd. "
        let todayDate = formatter.string(from: selectedDate)
        
        dateToRecord = todayDate + getDayOfWeek(selectedDate)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissStickerPopupView))
        imageContainer.addGestureRecognizer(tapGesture)
        
        let attrString = NSMutableAttributedString(string: emotionTextView.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        let fontAttr = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),  NSAttributedString.Key.foregroundColor: UIColor.white ]
        attrString.addAttributes(fontAttr, range: NSMakeRange(0, attrString.length))
        emotionTextView.autocorrectionType = .no
        emotionTextView.attributedText = attrString
        
    }
    
    @objc func dismissStickerPopupView() {
        if isStickerEditing {
            if isStickerGuideLineEditing {
                isStickerGuideLineEditing = false
                _selectedStickerView?.showEditingHandlers = false
            } else {
                isStickerEditing = false
                changeButtonContainerColor(false)
                changeStickerButtonInteraction(true)
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction,.curveLinear], animations: {
                    self.stickerPopupView.frame.origin.y += 700
                    
                }, completion: { _ in
                    self.stickerPopupView.animateStickerView(false)
                    self.stickerPopupView.frame.origin.y -= 700
                })
                makeButtonNormalOpacity()
                bottomContainer.backgroundColor = currentBackgroundColor
            }
        } else {
            if isStickerGuideLineEditing {
                isStickerGuideLineEditing = false
                _selectedStickerView?.showEditingHandlers = false
            } else {
                
            }
        }
        
    }
    
    @objc func dismissFrameButton() {
        isFrameEditing = false
    }
    
    @objc func dismissColorBottomContainer() {
        isColorEditing = false
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectIcon), name: .init("selectIcon"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getStickerName), name: .init("getStickerName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goOutToMain), name: .init("goOutToMain"), object: nil)
    }
    
    @objc private func goOutToMain(_ notification: Notification) {
        popupBackground.animatePopupBackground(false)
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let isCancel = userInfo["cancel"] as? Bool else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if isCancel {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func getStickerName(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let stickerName = userInfo["stickerName"] as? String else { return }
        
        addStickerToCropView(stickerName)
    }
    
    private func addStickerToCropView(_ stickerName: String) {
        
        let testImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        testImage.image = UIImage.init(named: stickerName)!
        testImage.contentMode = .scaleAspectFit
        let stickerView3 = StickerView.init(contentView: testImage)
        stickerView3.center = CGPoint.init(x: 150, y: 150)
        stickerView3.delegate = self
        stickerView3.setImage(UIImage.init(named: "iconCancelSticker")!, forHandler: StickerViewHandler.close)
        stickerView3.setImage(UIImage.init(named: "iconScale")!, forHandler: StickerViewHandler.rotate)
        stickerView3.showEditingHandlers = false
        isStickerGuideLineEditing = true
        stickerView3.tag = 999
        self.cropArea.addSubview(stickerView3)
        self.selectedStickerView = stickerView3
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
            isCategoryIconSelected = true
        } else if iconKind == "purpose" {
            purposeImageView.image = UIImage(named: iconImage)
            purposeLabel.text = iconName
            purposeImageName = iconImage
            isPurposeIconSelected = true
        } else {
            emotionImageView.image = UIImage(named: iconImage)
            emotionLabel.text = iconName
            emotionImageName = iconImage
            isEmotionIconSelected = true
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
            
            if isAppearing {
                self.bottomContainerConstarintWhenNameTextFieldTouched.priority = UILayoutPriority(rawValue: 1)
            }
            isNameTouched = false
            self.view.layoutIfNeeded()
        } else {
            if isAppearing {
                self.upperContainerConstraintWithImageContainerTop.priority =
                    UILayoutPriority(rawValue: 248)
            } else {
                self.upperContainerConstraintWithImageContainerTop.priority = UILayoutPriority(rawValue: 1000)
                self.bottomContainerConstarintWhenNameTextFieldTouched.priority = UILayoutPriority(rawValue: 1000)
            }
            UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                
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
        //        nameStackView.layoutIfNeeded()
        if let text = textField.text {
            if text.isEmpty {
                isNameTyped = false
            } else {
                isNameTyped = true
            }
        }
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
            self.cropImageView.image = editedImage
            self.originalFullImage = image
            self.emptyImageLabel.isHidden = true
            isImageSelected = true
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
    
    
    func sendIconDataButtonTapped() {
        popupBackground.animatePopupBackground(false)
        
    }
    
    
    func sendDateButtonTapped(_ date: Date?) {
        popupBackground.animatePopupBackground(false)
        if date == nil { return }
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd. "
        let todayDate = formatter.string(from: date!)
        
        dateToRecord = todayDate + getDayOfWeek(date!)
        selectedDate = date!
        isDateChanged = true
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

extension RecordVC: StickerViewDelegate {
    
    func stickerViewDidTap(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
        selectedStickerView?.showEditingHandlers = true
        isStickerGuideLineEditing = true
    }
    
    func stickerViewDidBeginMoving(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
        selectedStickerView?.showEditingHandlers = true
        isStickerGuideLineEditing = true
    }
    
    /// Other delegate methods which we not used currently but choose method according to your event and requirements.
    func stickerViewDidChangeMoving(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidEndMoving(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidBeginRotating(_ stickerView: StickerView) {
        selectedStickerView?.showEditingHandlers = true
    }
    
    func stickerViewDidChangeRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidEndRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidClose(_ stickerView: StickerView) {
        print("close")
    }
    //MARK: 추가한 선물 데이터 저장
    private func broadcastAdd(gift : Dictionary<String, Array<Dictionary<String, String>>>, isReceive: Bool){
        if let jsonData = try? JSONSerialization.data(withJSONObject: gift, options: .prettyPrinted) {
            if let json = try? JSONDecoder().decode(LoadAPIResponse.self, from: jsonData){
                
                if isReceive {
                    Gifts.receivedModels.insert(contentsOf: json.gifts, at: 0)
                }else{
                    Gifts.sentModels.insert(contentsOf: json.gifts, at: 0)
                }
                NotificationCenter.default.post(name: .init("addGift"), object: nil)
            }
        }
        
    }
}


extension RecordVC {
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return false
    }
}

extension UIView {
    
    func saveAsImage()-> UIImage? {
        UIGraphicsBeginImageContext(self.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        UIColor.clear.set()
        context.fill(self.bounds)
        
        self.isOpaque = false
        self.layer.isOpaque = false
        self.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
}
