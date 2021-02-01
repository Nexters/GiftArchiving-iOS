//
//  CollectionViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/01/30.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var constImgTop: NSLayoutConstraint!
    
    
    public func configure(with model: Model){
        
        self.imgView.image = UIImage(named: model.imageName)
        self.labelFrom.text = model.name
        self.labelDate.text = model.date
        
    }
    public func setLabelColor(colorIdx : Int){
        if(colorIdx == 3){
            labelFrom.textColor = UIColor.greyishBrown
            labelDate.textColor = UIColor.greyishBrownOpacity
        }else{
            labelFrom.textColor = UIColor.white
            labelDate.textColor = UIColor.whiteOpacity
        }
    }
    public func setConstraint(device: Int){
        if device == 1{
            constImgTop.setValue(64, forKey: "Constant")
            imgWidth.setValue(256, forKey: "Constant")
            imgHeight.setValue(256, forKey: "Constant")
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
        self.clipsToBounds = false
    }
}
