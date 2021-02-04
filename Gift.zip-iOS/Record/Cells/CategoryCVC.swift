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
    
    func setBorder() {
        for button in buttons {
            button.makeRounded(cornerRadius: 8.0)
        }
    }
    
    func setCategories() {
        
        for index in labels.indices {
            print(index)
        }
    }
    
    @IBAction func selectCategory(_ sender: UIButton) {
        print(sender)
        
        delegate?.iconSelectedAndDismissView()
        NotificationCenter.default.post(name: .init("selectIcon"), object: nil, userInfo: ["iconImageName": "icBaby", "iconName": "아기"])
    }
    
}

protocol CollectionViewButtonSelectedProtocol {
    func iconSelectedAndDismissView()
}

extension CollectionViewButtonSelectedProtocol {
    func iconSelectedAndDismissView() {}
}
