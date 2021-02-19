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
    }
    
    @IBAction func selectPackage(_ sender: Any) {
        NotificationCenter.default.post(name: .init("selectPackageCategory"), object: self, userInfo: ["index": index!])
    }
}
