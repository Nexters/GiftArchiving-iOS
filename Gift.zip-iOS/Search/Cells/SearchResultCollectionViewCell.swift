//
//  SearchResultCollectionViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/09.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVIew: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var backView: UIView!
    
    public func configure(with model: Gift, color : UIColor){
        
        self.imgVIew.image = UIImage(named: "img_test")
        self.labelName.text = model.name
        self.labelDate.text = model.receiveDate
        self.backView.backgroundColor = color
        self.labelDate.textColor = UIColor.whiteOpacity
    }
}
