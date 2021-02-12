//
//  ShareVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/08.
//

import UIKit
import KakaoSDKLink

class ShareVC: UIViewController {
    
    @IBOutlet weak var croppedImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var envelopImage: UIImage?
    var currentBackgroundColor: UIColor?
    var currentName: String?
    var instagramImage: UIImage?
    var currentFrameOfImage: FrameOfImage?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cardView.backgroundColor = currentBackgroundColor
        cardView.makeRounded(cornerRadius: 8.0)
        nameLabel.text = currentName
        
        logoImageView.backgroundColor = currentBackgroundColor
        if currentBackgroundColor == .wheat {
            switch currentFrameOfImage {
            case .square:
                logoImageView.image = UIImage(named: "logoYellowRectangle")
                break
            case .circle:
                logoImageView.image = UIImage(named: "logoYellowCircle")
                break
            case .full:
                logoImageView.image = UIImage(named: "logoYellowRectangle")
                break
            case .windowFrame:
                logoImageView.image = UIImage(named: "logoYellowWindow")
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [.repeat,.autoreverse,.curveEaseIn], animations: {
            self.cardView.frame.origin.y = self.cardView.frame.origin.y + 52
        }, completion: {_ in
        })
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        croppedImageView.image = envelopImage
    }
    
    
    
    @IBAction func popToMain(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
        
        UIImageWriteToSavedPhotosAlbum(instagramImage!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            self.showToast(text: "저장이 완료되었습니다.")
        } else {
            print("error saving cropped image")
        }
    }
    
    @IBAction func shareToInstagramButtonTapped(_ sender: Any) {
        guard let insta = self.storyboard?.instantiateViewController(identifier: "InstagramShareVC") as? InstagramShareVC else { return }
        insta.instagramImage = instagramImage
        insta.modalPresentationStyle = .fullScreen
        self.present(insta, animated: true, completion: nil)
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

