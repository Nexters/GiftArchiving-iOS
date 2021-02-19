//
//  InstagramShareVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/12.
//

import UIKit
import Photos

class InstagramShareVC: UIViewController, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var myPhonePhoto: UIImage?
    var instagramImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = instagramImage
    }
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareStory(_ sender: Any) {
        let pngFile = changeImageToPNG(instagramImage!)
        shareToInstagramStory(pngFile)
    }
    
    @IBAction func shareFeed(_ sender: Any) {
//        let pngFile = changeImageToPNG(instagramImage!)
        postImage(image: myPhonePhoto!)
    }
    
    
    func postImage(image: UIImage, result:((Bool)->Void)? = nil) {
        guard let instagramURL = URL(string: "instagram://app") else {
            if let result = result {
                result(false)
            }
            return
        }
        
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                
                let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
                let shareURL = "instagram://library?LocalIdentifier=" + assetID
                
                if UIApplication.shared.canOpenURL(instagramURL) {
                    if let urlForRedirect = URL(string: shareURL) {
                        UIApplication.shared.open(urlForRedirect, options: [:], completionHandler: nil)
                    }
                }
            }
        } catch {
            if let result = result {
                result(false)
            }
        }
    }
    
    
    private func changeImageToPNG(_ image: UIImage) -> Data {
        guard let imageData = image.pngData() else
        { return Data() }
        
        return imageData
    }
    
    private func shareToInstagramStory(_ imageData: Data) {
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
            if UIApplication.shared.canOpenURL(storyShareURL) {
                UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
            }
        } else {
            let alert = UIAlertController(title: "알림", message: "인스타그램이 필요합니다", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
