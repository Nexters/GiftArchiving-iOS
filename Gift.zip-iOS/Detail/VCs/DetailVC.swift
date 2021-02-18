//
//  DetailVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/14.
//

import UIKit
import Kingfisher

class DetailVC: UIViewController {
    
    @IBOutlet weak var upperContainer: UIView!
    @IBOutlet weak var topSafeAreaView: UIView!
    
    @IBOutlet weak var isReceiveLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet var tagButtons: [UIButton]!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var purposeImageView: UIImageView!
    @IBOutlet weak var feelingImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet var textsToChangeColor: [UILabel]!
    
    var giftId: String = "602d16ef00eec17e8db2b4e9"
    var currentBackgroundColor: String = "charcoalGrey"
    
    lazy var popupBackground = UIView()
    
    private var giftImage: UIImage?
    private var bgImgURL: String?
    private var receiveDate: String?
    private var isReceiveGift: Bool = true
    private var isGiftEditing: Bool = false {
        didSet {
            nameLabel.isUserInteractionEnabled = false
            if isGiftEditing {
                contentTextView.isUserInteractionEnabled = true
                for button in tagButtons {
                    button.isUserInteractionEnabled = true
                }
                
                let image = currentBackgroundColor == "wheat" ? "iconCheckBk" : "iconCheck"
                moreButton.setImage(UIImage(named: image), for: .normal)
                
            } else {
                contentTextView.isUserInteractionEnabled = false
                for button in tagButtons {
                    button.isUserInteractionEnabled = false
                }
                let image = currentBackgroundColor == "wheat" ? "iconMoreBk" : "iconMore"
                moreButton.setImage(UIImage(named: image), for: .normal)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 선물기록 정보들 가져오기
        GiftService.shared.getOneGift(id: giftId) { (result) in
            switch result {
            case .success(let data):
                guard let gift = data as? GiftModel else { return }
                print(self.giftId)
                print(gift.receiveDate)
                if gift.bgColor == "wheat" {
                    for label in self.textsToChangeColor {
                        label.textColor = .black
                    }
                    self.contentTextView.textColor = .black
                    self.dateLabel.textColor = .black
                    self.nameLabel.textColor = .black
                    let exitImage = UIImage(named: "iconCancelBk")
                    self.exitButton.setImage(exitImage, for: .normal)
                    let moreImage = UIImage(named: "iconMoreBk")
                    self.moreButton.setImage(moreImage, for: .normal)
                } else {
                    
                }
                self.currentBackgroundColor = gift.bgColor
                self.bgImgURL = gift.bgImgURL
                self.receiveDate = gift.receiveDate
                self.isReceiveGift = gift.isReceiveGift
                self.upperContainer.backgroundColor = UIColor.init(named: gift.bgColor)
                self.view.backgroundColor = UIColor.init(named: gift.bgColor)
                self.setPageInformation(
                    imageURL: gift.noBgImgURL,
                    name: gift.name,
                    receiveDate: gift.receiveDate,
                    isReceiveGift: gift.isReceiveGift,
                    category: gift.category,
                    emotion: gift.emotion,
                    reason: gift.reason,
                    content: gift.content,
                    bgColor: gift.bgColor)
                
            case .requestErr(let message):
                guard let message = message as? String else { return }
                let alertViewController = UIAlertController(title: "통신 실패", message: message, preferredStyle: .alert)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for btn in tagButtons {
            btn.makeRounded(cornerRadius: 8.0)
        }
        isGiftEditing = false
        popupBackground.setPopupBackgroundView(to: view)
        NotificationCenter.default.addObserver(self, selector: #selector(selectIcon), name: .init("selectIcon"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(popupChange), name: .init("popupchange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(broadcastDelete), name: .init("broadcastDelete"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(broadcastUpdate(_:)), name: .init("broadcastUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editGift), name: .init("editGift"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(shareGift), name: .init("shareGift"), object: nil)
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
        // 기기별 bottom safearea 계산하기
        let heightConstant = isAppearing ? keyboardHeight - 21 : 13
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            
            if isAppearing {
                self.topConstraint.priority = UILayoutPriority(rawValue: 248)
            } else {
                self.topConstraint.priority = UILayoutPriority(rawValue: 1000)
            }
            self.bottomConstraint.constant = heightConstant
            self.view.layoutIfNeeded()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .init("broadcastUpdate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: .init("popupchange"), object: nil)
        NotificationCenter.default.removeObserver(self, name: .init("broadcastDelete"), object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // UI 작업
    private func setPageInformation(imageURL : String, name: String, receiveDate: String, isReceiveGift: Bool,  category: String, emotion: String, reason: String, content: String, bgColor: String) {
        
        let url = URL(string: imageURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) //
        giftImageView.kf.setImage(with: url)
        giftImage = giftImageView.image
        nameLabel.text = name
        isReceiveLabel.text = isReceiveGift ? "From." : "To."
        let dateBeforeParsing: String = receiveDate.components(separatedBy: "T")[0]
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateBeforeParsing)
        formatter.dateFormat = "yyyy.MM.dd "
        let dateAfterParsing = formatter.string(from: date!)
        let dateToRecord = dateAfterParsing + getDayOfWeek(date!)
        dateLabel.text = dateToRecord
        topSafeAreaView.backgroundColor = UIColor.init(named: bgColor)
        var categoryName: String = "카테고리"
        var purposeName: String = "목적"
        var emotionName: String = "감정"
        var categoryImageName: String = category
        var purposeImageName: String = reason
        var emotionImageName: String = emotion
        for c in Icons.category {
            if c.englishName == category {
                categoryName = c.name
                categoryImageName = c.imageName
                if bgColor == "wheat" {
                    categoryImageName += "B"
                }
            }
        }
        for p in Icons.purpose{
            if p.englishName == reason {
                purposeName = p.name
                purposeImageName = p.imageName
                if bgColor == "wheat" {
                    purposeImageName += "B"
                }
            }
        }
        
        if isReceiveGift {
            for e in Icons.emotionGet {
                if e.englishName == emotion {
                    emotionName = e.name
                    emotionImageName = e.imageName
                    if bgColor == "wheat" {
                        emotionImageName += "B"
                    }
                }
            }
        } else {
            for e in Icons.emotionSend {
                if e.englishName == emotion {
                    emotionName = e.name
                    emotionImageName = e.imageName
                    if bgColor == "wheat" {
                        emotionImageName += "B"
                    }
                }
            }
        }
        
        // 아이콘 검은색으로 바꾸기
        
        categoryLabel.text = categoryName
        categoryImageView.image = UIImage.init(named: categoryImageName)
        purposeLabel.text = purposeName
        purposeImageView.image = UIImage.init(named: purposeImageName)
        emotionLabel.text = emotionName
        feelingImageView.image = UIImage.init(named: emotionImageName)
        contentTextView.text = content
        
        
        
    }
    
    // 요일 생성
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
            feelingImageView.image = UIImage(named: iconImage)
            emotionLabel.text = iconName
        }
    }
    
    
    @objc func shareGift() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
            
            let sb = UIStoryboard.init(name: "Share", bundle: nil)
            guard let share = sb.instantiateViewController(identifier: "ShareVC") as? ShareVC else { return }
            share.whereToGo = 1
            share.envelopImage = self.giftImage
            
            share.currentName = "\(self.isReceiveLabel.text!) \(self.nameLabel.text!)"
            share.currentBackgroundColor = UIColor(named: self.currentBackgroundColor)
            share.kakaoImageURL = self.bgImgURL
            //            share.instagramImage = instagramSquareImage
            //            // instagramSquareImage
            //            share.myPhonePhoto = myPhonePhoto
            //            // myPhonePhoto
            //            share.currentFrameOfImage = currentFrameOfImage
            //            share.userName = nameTextField.text
            share.modalPresentationStyle = .fullScreen
            self.present(share, animated: true, completion: nil)
        }
    }
    
    @objc func editGift() {
        
        isGiftEditing = true
    }
    
    @objc func popupChange() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
            
            guard let deleteVC = self.storyboard?.instantiateViewController(identifier: "DeleteDetailVC") as? DeleteDetailVC else { return }
            deleteVC.giftId = self.giftId
            deleteVC.modalPresentationStyle = .overCurrentContext
            self.present(deleteVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func categoryButtonTapped(_ sender: Any) {
        popupBackground.animatePopupBackground(true)
        guard let vc = UIStoryboard.init(name: "Record", bundle: nil).instantiateViewController(identifier: "IconPopupVC") as? IconPopupVC else { return }
        view.bringSubviewToFront(categoryLabel)
        view.bringSubviewToFront(categoryImageView)
        vc.whichPopup = 0
        var color: UIColor?
        switch currentBackgroundColor {
        case "charcoalGrey":
            color = .charcoalGrey
            break
        case "ceruleanBlue":
            color = .ceruleanBlue
            break
        case "wheat":
            color = .wheat
            break
        case "pinkishOrange":
            color = .pinkishOrange
            break
        default:
            break
        }
        vc.backgroundColor = color
        vc.popupViewHeightByPhones = self.view.frame.height - categoryLabel.frame.maxY - 49
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func purposeButtonTapped(_ sender: Any) {
        
        popupBackground.animatePopupBackground(true)
        guard let vc = UIStoryboard.init(name: "Record", bundle: nil).instantiateViewController(identifier: "IconPopupVC") as? IconPopupVC else { return }
        view.bringSubviewToFront(purposeLabel)
        view.bringSubviewToFront(purposeImageView)
        vc.whichPopup = 1
        var color: UIColor?
        switch currentBackgroundColor {
        case "charcoalGrey":
            color = .charcoalGrey
            break
        case "ceruleanBlue":
            color = .ceruleanBlue
            break
        case "wheat":
            color = .wheat
            break
        case "pinkishOrange":
            color = .pinkishOrange
            break
        default:
            break
        }
        vc.backgroundColor = color
        vc.popupViewHeightByPhones = self.view.frame.height - categoryLabel.frame.maxY - 49
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func emotionButtonTapped(_ sender: Any) {
        
        popupBackground.animatePopupBackground(true)
        guard let vc = UIStoryboard.init(name: "Record", bundle: nil).instantiateViewController(identifier: "IconPopupVC") as? IconPopupVC else { return }
        view.bringSubviewToFront(emotionLabel)
        view.bringSubviewToFront(feelingImageView)
        vc.whichPopup = 2
        var color: UIColor?
        switch currentBackgroundColor {
        case "charcoalGrey":
            color = .charcoalGrey
            break
        case "ceruleanBlue":
            color = .ceruleanBlue
            break
        case "wheat":
            color = .wheat
            break
        case "pinkishOrange":
            color = .pinkishOrange
            break
        default:
            break
        }
        vc.backgroundColor = color
        vc.popupViewHeightByPhones = self.view.frame.height - categoryLabel.frame.maxY - 49
        vc.isReceiveGift = isReceiveGift
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func dismissDetail(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreButtonTapped(_ sender: Any) {
        if isGiftEditing {
            // 통신
            if !contentTextView.text.isEmpty {
                var category: String = ""
                var emotion: String = ""
                var reason: String = ""
                let content: String = contentTextView.text
                
                for c in Icons.category {
                    if categoryLabel.text == c.name {
                        category = c.englishName
                    }
                }
                if isReceiveGift {
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

                GiftService.shared.putGift(category: category, content: content, emotion: emotion, reason: reason, receiveDate: receiveDate!, giftId: giftId)  { networkResult -> Void in
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
                        self.isGiftEditing = false
                    }
                }
            } else {
                let alertViewController = UIAlertController(title: "저장 실패", message: "내용을 입력해주세요. 🥰", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertViewController.addAction(action)
                self.present(alertViewController, animated: true, completion: nil)
            }
            
        } else {
            guard let moreVC = self.storyboard?.instantiateViewController(identifier: "DetailMoreVC") as? DetailMoreVC else { return }
            
            moreVC.currentBackgroundColor = self.currentBackgroundColor
            moreVC.modalPresentationStyle = .overCurrentContext
            self.present(moreVC, animated: true, completion: nil)
        }
        
    }
    
    //MARK: 삭제 API success 후,  로컬에서도 삭제시키기
    @objc func broadcastDelete(){
        var target = -1
        var idx = 0
        for model in Gifts.receivedModels{
            if model.id == giftId {
                target = idx
                break
            }
            idx += 1
        }
        if target != -1 {
            Gifts.receivedModels.remove(at: target)
        }else{
            idx = 0
            for model in Gifts.sentModels{
                if model.id == giftId {
                    target = idx
                    break
                }
                idx += 1
            }
            Gifts.sentModels.remove(at: target)
        }
        if let vcCnt = self.navigationController?.viewControllers.count{
            if let searchVC = self.navigationController?.viewControllers[vcCnt - 2] as? SearchVC{
                searchVC.deleteGift(giftId: giftId)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func broadcastUpdate(_ notification: Notification){
        guard let name = notification.userInfo?["name"] as? String else { return }
        guard let content = notification.userInfo?["content"] as? String else { return }
        var target = -1
        var idx = 0
        for model in Gifts.receivedModels{
            if model.id == giftId {
                target = idx
                break
            }
            idx += 1
        }
        if target != -1 {
            Gifts.receivedModels[target].content = content
            Gifts.receivedModels[target].name = name
        }else{
            idx = 0
            for model in Gifts.sentModels{
                if model.id == giftId {
                    target = idx
                    break
                }
                idx += 1
            }
            Gifts.sentModels[target].content = content
            Gifts.sentModels[target].name = name
        }
        if let vcCnt = self.navigationController?.viewControllers.count{
            if let searchVC = self.navigationController?.viewControllers[vcCnt - 2] as? SearchVC{
                searchVC.updateGift(giftId: giftId, content: content, name: name)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
