//
//  OnboardingCollectionViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/06.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var labelTop1: UILabel!
    
    @IBOutlet weak var labelTop2: UILabel!
    
    @IBOutlet weak var labelTop3: UILabel!
    
    @IBOutlet weak var cnstImgViewTop: NSLayoutConstraint!
    func configure( img : UIImage, txtTop1: String, txtTop2: String, txtTop3: String, device: Int ) {
        imgView.image = img;
        labelTop1.text = txtTop1
        labelTop2.text = txtTop2
        labelTop3.text = txtTop3
        labelTop3.textColor = UIColor.whiteOpacity
        if device == 0 {
            cnstImgViewTop.constant = 20
        }
    }
}
