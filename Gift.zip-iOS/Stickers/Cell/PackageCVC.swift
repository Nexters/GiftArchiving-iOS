//
//  PackageCVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/19.
//

import UIKit

class PackageCVC: UICollectionViewCell {
    static let identifier: String = "PackageCVC"
    @IBOutlet weak var imageView: UIImageView!
    
    var imageName: String?
    func setSticker(imageName: String) {
        imageView.image = UIImage.init(named: imageName)
        self.imageName = imageName
    }
    
    @IBAction func selectSticker(_ sender: Any) {
        NotificationCenter.default.post(name: .init("getStickerName"), object: nil, userInfo: ["stickerName": imageName!])
    }
    
}
