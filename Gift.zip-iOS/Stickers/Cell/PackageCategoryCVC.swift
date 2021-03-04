//
//  PackageCategoryCVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/19.
//

import UIKit

class PackageCategoryCVC: UICollectionViewCell {
    static let identifier: String = "PackageCategoryCVC"
    
    @IBOutlet weak var imageView: UIImageView!
    var imageName: String?
    var index: Int?
    
    func setSticker(imageName: String) {
        imageView.image = UIImage.init(named: imageName)
        self.imageName = imageName
        
        imageView.layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOpacity = 5
        imageView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        
        self.layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 10
        self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    }
    
    @IBAction func selectPackage(_ sender: Any) {
        NotificationCenter.default.post(name: .init("noticePackageStickerSelected"), object: self)
        NotificationCenter.default.post(name: .init("selectPackageCategory"), object: self, userInfo: ["index": index!])
    }
}
