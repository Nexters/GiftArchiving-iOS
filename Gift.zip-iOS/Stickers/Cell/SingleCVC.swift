//
//  SingleCVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/06.
//

import UIKit

class SingleCVC: UICollectionViewCell {
    static let identifier: String = "SingleCVC"
    @IBOutlet weak var imageView: UIImageView!
    
    func setSticker(imageName: String) {
        imageView.image = UIImage.init(named: imageName)
    }
}
