//
//  FooterTVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/07.
//

import UIKit

class FooterTVC: UITableViewCell {
    static let identifier: String = "FooterTVC"

    weak var delegate: UITableViewButtonSelectedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func logout(_ sender: UIButton) {
        delegate?.logoutButtonPressed()
    }
}
