//
//  NoticeTVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/19.
//

import UIKit

class NoticeTVC: UITableViewCell {
    static let identifier: String = "NoticeTVC"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setInformation(title: String, content: String, date: String) {
        titleLabel.text = title
        contentLabel.text = content
        dateLabel.text = date
    }
}
