//
//  CategorySecondCell.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/04.
//

import UIKit

class CategorySecondCVC: UICollectionViewCell {
    static let identifier: String = "CategorySecondCVC"
    
    var categoryImageArray: [String] = ["icCosmetic", "icMcoupon", "icCulture", "icEtc"]
    var categoryNameArray: [String] = ["화장품", "모바일교환권", "컬처", "기타"]
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var images: [UIImageView]!
    @IBOutlet var labels: [UILabel]!
    
    var popupBackgroundColor: UIColor?
    var delegate: CollectionViewButtonSelectedProtocol?
    
    func setBorder() {
        for button in buttons {
            button.makeRounded(cornerRadius: 8.0)
        }
    }
    
    func setCategories() {
        for index in labels.indices {
            labels[index].text = categoryNameArray[index]
            images[index].image = UIImage.init(named: categoryImageArray[index])
        }
    }
    
    
    @IBAction func selectIcon(_ sender: UIButton) {
        delegate?.iconSelectedAndDismissView()
        for index in buttons.indices {
            if buttons[index] == sender {
                NotificationCenter.default.post(name: .init("selectIcon"), object: nil, userInfo: ["iconImageName": categoryImageArray[index], "iconName": categoryNameArray[index]])
            }
        }
    }
    
}
