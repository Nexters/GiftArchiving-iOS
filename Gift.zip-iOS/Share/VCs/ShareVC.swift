//
//  ShareVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/08.
//

import UIKit
import KakaoSDKLink
import KakaoSDKAuth
import KakaoSDKTalk

class ShareVC: UIViewController {
    
    @IBOutlet weak var croppedImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var croppedImage: UIImage?
    var currentBackgroundColor: UIColor?
    var currentName: String?
    var letterImage: UIImage?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cardView.backgroundColor = currentBackgroundColor
        cardView.makeRounded(cornerRadius: 8.0)
        nameLabel.text = currentName
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat,.autoreverse,.curveEaseIn], animations: {}) { _ in
        
        UIView.animate(withDuration: 3.0, delay: 0.9, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.repeat,.autoreverse,.curveEaseIn], animations: {
            self.cardView.frame.origin.y = self.cardView.frame.origin.y + 52
        }, completion: {_ in
        })
        
        //        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        croppedImageView.image = letterImage
    }
    
    private func changeImageToPNG(_ image: UIImage) -> Data {
        guard let imageData = image.pngData() else
        {return Data() }
        
        return imageData
    }
    
    private func shareToInstagram(_ imageData: Data) {
        let pasteboardItems : [String:Any] = [
            "com.instagram.sharedSticker.stickerImage": imageData,
            "com.instagram.sharedSticker.backgroundTopColor" : "#000000",
            "com.instagram.sharedSticker.backgroundBottomColor" : "#000000",
            
        ]
        
        let pasteboardOptions = [
            UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(300)
        ]
        
        UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
        
        if let storyShareURL = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storyShareURL)
            {
                UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
            }
        }  else
        {
            let alert = UIAlertController(title: "알림", message: "인스타그램이 필요합니다", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func popToMain(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
        
        UIImageWriteToSavedPhotosAlbum(croppedImage!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func shareToInstagramButtonTapped(_ sender: Any) {
        let pngFile = changeImageToPNG(croppedImage!)
        shareToInstagram(pngFile)
    }
    
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            print("saved cropped image")
        } else {
            print("error saving cropped image")
        }
    }
    @IBAction func shareToKakaoButtonTapped(_ sender: UIButton) {
        let title: String = "🎁기프트집 선물 도착🎁"
        let description: String = "\n님이 나에게 보낸 선물이 도착했어요!"
        let imageURL: String = "https://gift-zip.s3.ap-northeast-2.amazonaws.com/000871.31eedc54c602460da26f4765dd27e985.1412/test2.jpegFri Feb 12 03:20:19 KST 2021"
        let templateId = 47251

        LinkApi.shared.customLink(templateId: Int64(templateId), templateArgs:["title": title, "description": description, "imageURL": imageURL]) { (linkResult, error) in
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
}

extension ShareVC {
}
