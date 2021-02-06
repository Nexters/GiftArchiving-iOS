//
//  OnboardingCollectionViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/06.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    func configure( img : UIImage ) {
        imgView.image = img;
    }
}
