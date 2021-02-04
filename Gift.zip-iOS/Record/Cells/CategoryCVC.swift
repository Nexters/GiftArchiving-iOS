//
//  CategoryCVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/04.
//

import UIKit

class CategoryCVC: UICollectionViewCell {
    static let identifier: String = "CategoryCVC"
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var images: [UIImageView]!
    
    var popupBackgroundColor: UIColor?
    var delegate: CollectionViewButtonSelectedProtocol?
    var iconKind: String?
    
    
    func setBorder() {
        for button in buttons {
            button.makeRounded(cornerRadius: 8.0)
        }
    }
    
    func setCategories(iconNames: [String], iconImages: [String]) {
        for index in labels.indices {
            labels[index].text = iconNames[index]
            images[index].image = UIImage.init(named: iconImages[index])
        }
    }
    
    @IBAction func selectCategory(_ sender: UIButton) {
        
        for index in buttons.indices {
            if buttons[index] == sender {
                delegate?.iconSelectedAndDismissView(index: index, from: 1, iconKind: iconKind!)
                
            }
        }
    }
}

protocol CollectionViewButtonSelectedProtocol {
    func iconSelectedAndDismissView(index: Int, from: Int, iconKind: String)
}

extension CollectionViewButtonSelectedProtocol {
    func iconSelectedAndDismissView(index: Int, from: Int, iconKind: String) {}
}
