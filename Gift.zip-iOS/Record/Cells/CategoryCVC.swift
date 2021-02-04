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
    
    var categoryImageArray: [String] = ["icDigital", "icGroceries", "icLiving", "icPet", "icBaby", "icGiftCard", "icSports", "icFashion"]
    var categoryNameArray: [String] = ["디지털", "식품", "리빙", "펫", "유아동", "상품권", "스포츠", "패션"]
    
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
    
    @IBAction func selectCategory(_ sender: UIButton) {
        delegate?.iconSelectedAndDismissView()
        for index in buttons.indices {
            if buttons[index] == sender {
                NotificationCenter.default.post(name: .init("selectIcon"), object: nil, userInfo: ["iconImageName": categoryImageArray[index], "iconName": categoryNameArray[index]])
            }
        }
    }
}

protocol CollectionViewButtonSelectedProtocol {
    func iconSelectedAndDismissView()
}

extension CollectionViewButtonSelectedProtocol {
    func iconSelectedAndDismissView() {}
}
