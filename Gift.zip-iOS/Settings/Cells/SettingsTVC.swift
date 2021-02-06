//
//  SettingsTVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/06.
//

import UIKit

class SettingsTVC: UITableViewCell {
    static let identifier: String = "SettingsTVC"
    @IBOutlet weak var settingIconImageView: UIImageView!
    @IBOutlet weak var settingNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setInformations(settingIconName: String, settingIconImageName: String) {
        settingNameLabel.text = settingIconName
        settingIconImageView.image = UIImage.init(named: settingIconImageName)
    }
}
