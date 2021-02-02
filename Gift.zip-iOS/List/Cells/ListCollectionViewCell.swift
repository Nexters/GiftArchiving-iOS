//
//  ListCollectionViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/02.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var backingVIew: UIView!
    public var city: String? {
        didSet {
            cityLabel.text = city
        }
    }
    
    public var color: UIColor? {
        didSet {
            backingVIew.backgroundColor = color
        }
    }
    
    override func awakeFromNib() {
        backingVIew.layer.cornerRadius = 12
        backingVIew.layer.masksToBounds = true
    }
}
