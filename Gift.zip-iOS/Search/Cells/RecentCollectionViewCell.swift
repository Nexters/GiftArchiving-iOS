//
//  RecentCollectionViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/07.
//

import UIKit

class RecentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTxt: UILabel!
    func configure( txt : String ) {
        labelTxt.text = txt;
        labelTxt.backgroundColor = UIColor.charcoalGreyThree
    }
}
