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

    func setBorder() {
        for button in buttons {
            button.makeRounded(cornerRadius: 8.0)
        }
    }
    
    @IBAction func selectCategory(_ sender: UIButton) {
        print(sender)
    }
    
}
