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
    

    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet var textsToChangeColor: [UILabel]!
    var giftId: String = "6024c92e0b372841ffb814b8"
    var currentBackgroundColor: String = "charcoalGrey"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 선물기록 정보들 가져오기
        GiftService.shared.getOneGift(id: giftId) { (result) in
            switch result {
            case .success(let data):
                guard let gift = data as? GiftModel else { return }
                
                if gift.bgColor == "wheat" {
                    for label in self.textsToChangeColor {
                        label.textColor = .black
                    }
                    self.contentTextView.textColor = .black
                    self.dateLabel.textColor = .black
                    self.nameLabel.textColor = .black
                    
                } else {
                    
                }
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
        NotificationCenter.default.addObserver(self, selector: #selector(popupChange), name: .init("popupchange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(broadcastDelete), name: .init("broadcastDelete"), object: nil)
    }
    
    
    // UI 작업
    private func setPageInformation(imageURL : String, name: String, receiveDate: String, isReceiveGift: Bool,  category: String, emotion: String, reason: String, content: String, bgColor: String) {

        let url = URL(string: imageURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)
        giftImageView.kf.setImage(with: url)
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
    
    @objc func popupChange() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
            
            guard let deleteVC = self.storyboard?.instantiateViewController(identifier: "DeleteDetailVC") as? DeleteDetailVC else { return }
            
            deleteVC.giftId = self.giftId
            deleteVC.modalPresentationStyle = .overCurrentContext
            self.present(deleteVC, animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBAction func dismissDetail(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreButtonTapped(_ sender: Any) {
        
        guard let moreVC = self.storyboard?.instantiateViewController(identifier: "DetailMoreVC") as? DetailMoreVC else { return }
        
        moreVC.currentBackgroundColor = self.currentBackgroundColor
        moreVC.modalPresentationStyle = .overCurrentContext
        self.present(moreVC, animated: true, completion: nil)
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
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
