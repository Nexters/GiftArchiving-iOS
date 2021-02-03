//
//  ListCollectionViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/02.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    public func configure(with model: Model, color : UIColor){
        
        self.imgView.image = UIImage(named: model.imageName)
        self.labelName.text = model.name
        self.labelDate.text = model.date
        self.backgroundColor = color
        if color == UIColor(named: "wheat") {
            labelName.textColor = UIColor.greyishBrown
            labelDate.textColor = UIColor.greyishBrownOpacity
        }else{
            labelName.textColor = UIColor.white
            labelDate.textColor = UIColor.whiteOpacity
        }
        
    }
}
