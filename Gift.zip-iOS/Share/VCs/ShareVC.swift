//
//  ShareVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/08.
//

import UIKit
import KakaoSDKLink
import KakaoSDKTemplate
import KakaoSDKCommon

class ShareVC: UIViewController {
    
    @IBOutlet weak var croppedImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var shareButtons: UIStackView!
    @IBOutlet weak var kakaoImageCroppedArea: UIView!
    
    var envelopImage: UIImage?
    var currentBackgroundColor: UIColor?
    var currentName: String?
    var instagramImage: UIImage?
    var currentFrameOfImage: FrameOfImage?
    var userName: String?
    var kakaoImageURL: String?
    var isReceiveGift: Bool?
    var giftId: String?
    
    var viewWillAppearCnt = 0

    var myPhonePhoto: UIImage?
    var whereToGo: Int = 0

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cardView.backgroundColor = currentBackgroundColor
        cardView.makeRounded(cornerRadius: 8.0)
        nameLabel.text = currentName
        
        logoImageView.backgroundColor = currentBackgroundColor
        if currentBackgroundColor == .wheat {
            print("HELLO")
            nameLabel.textColor = UIColor(white: 41.0 / 255.0, alpha: 1.0)
            logoImageView.image = UIImage(named: "logoBgcolorNoneBlack")
            switch currentFrameOfImage {
            case .square:
                break
            case .circle:
                let radius = logoImageView.layer.bounds.width / 2
                logoImageView.makeRounded(cornerRadius: radius)
                break
            case .full:
                break
            case .windowFrame:
                let radius = logoImageView.layer.bounds.width / 2
                logoImageView.roundCorners(cornerRadius: radius, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
                break
            case .none:
                break
            }
        } else {
            switch currentFrameOfImage {
            case .square:
                break
            case .circle:
                let radius = logoImageView.bounds.width / 2
                logoImageView.makeRounded(cornerRadius: radius)
                break
            case .full:
                break
            case .windowFrame:
                let radius = logoImageView.bounds.width / 2
                logoImageView.roundCorners(cornerRadius: radius, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
                break
            case .none:
                break
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if viewWillAppearCnt < 2 {
            self.cardView.frame.origin.y = self.cardView.frame.origin.y + 52
            self.viewWillAppearCnt += 1
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        croppedImageView.image = envelopImage
        
        UIView.animate(withDuration: 3.0, delay: 1.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [.curveEaseIn], animations: {
            self.cardView.frame.origin.y = self.cardView.frame.origin.y + 52
        }, completion: {_ in
        })
        
        
        
    }
    
    
    private func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor(red: 141.0 / 255.0, green: 141.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0)
        toastLabel.textColor = UIColor.black
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0).isActive = true
        toastLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16.0).isActive = true
        toastLabel.topAnchor.constraint(equalTo: shareButtons.topAnchor, constant: 0.0).isActive = true
        toastLabel.heightAnchor.constraint(equalToConstant: 56.0).isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1
            
        },completion: { finish in
            UIView.animate(withDuration: 0.3, delay: 0.7, animations: {
                toastLabel.alpha = 0

            }, completion: { finish in
                if finish {
                    toastLabel.removeFromSuperview()
                }
            })
        })
    }
    
    @IBAction func popToMain(_ sender: Any) {
        if whereToGo == 0 {
            guard let navivc = self.navigationController else { return }
            let main = navivc.viewControllers[navivc.viewControllers.count - 3]
            navivc.popToViewController(main, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
        
        UIImageWriteToSavedPhotosAlbum(myPhonePhoto!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            showToast(message: "저장이 완료되었습니다.", font: UIFont(name: "SpoqaHanSansNeo-Bold", size: 16) ?? UIFont())
            self.view.layoutIfNeeded()
        } else {
            showToast(message: "앨범 접근을 허용해주세요.", font: UIFont(name: "SpoqaHanSansNeo-Regular", size: 16) ?? UIFont())
            print("error saving cropped image")
        }
    }
    
    @IBAction func shareToInstagramButtonTapped(_ sender: Any) {
        guard let insta = self.storyboard?.instantiateViewController(identifier: "InstagramShareVC") as? InstagramShareVC else { return }
        insta.instagramImage = instagramImage
        insta.myPhonePhoto = myPhonePhoto
        insta.modalPresentationStyle = .fullScreen
        self.present(insta, animated: true, completion: nil)
    }
    
    
    @IBAction func shareToKakaoButtonTapped(_ sender: UIButton) {
        let title: String = "🎁기프트집 선물 도착🎁"
        let description: String =
            isReceiveGift ?? true ? "\(userName!)님이 나에게 보낸 선물이 도착했어요!" : "\(userName!)님에게 보낸 선물이 도착했어요!"
        let imageURL: String = kakaoImageURL!
        let templateId = 47251
        
        LinkApi.shared.customLink(templateId: Int64(templateId), templateArgs:["title": title, "description": description, "imageURL": imageURL, "giftId": giftId!]) { (linkResult, error) in
            if let error = error {
                print(error)
            }
            else {
                print("customLink() success.")
                if let linkResult = linkResult {
                    UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func makeFeedMessage() {
        let title: String = "🎁기프트집 선물 도착🎁"
        let description: String =
            isReceiveGift ?? true ? "\(userName!)님이 나에게 보낸 선물이 도착했어요!" : "\(userName!)님에게 보낸 선물이 도착했어요!"
        let imageURL: String = kakaoImageURL!
        
         let feedTemplateJsonStringData =
             """
             {
                 "object_type": "feed",
                 "content": {
                     "title": \(title),
                     "description": \(description),
                     "image_url": \(imageURL),
                     "link": {
                             "android_execution_params": "gift_id=2",
                             "ios_execution_params": "gift_id=2"
                     }
                 },
                 "buttons": [
                     {
                         "title": "구경하기",
                         "link": {
                             "android_execution_params": "gift_id=2",
                             "ios_execution_params": "gift_id=2"
                         }
                     }
                 ]
             }
             """.data(using: .utf8)!
         
         if let templatable = try? SdkJSONDecoder.custom.decode(FeedTemplate.self, from: feedTemplateJsonStringData) {
             
             LinkApi.shared.defaultLink(templatable: templatable) {(linkResult, error) in
                 if let error = error {
                     print(error)
                 }
                 else {
                     print("defaultLink() success.")
                     if let linkResult = linkResult {
                         UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                     }
                 }
             }
         } else {
             print("Templatable error")
         }

    }
}

