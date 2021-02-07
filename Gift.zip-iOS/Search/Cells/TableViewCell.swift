//
//  TableViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/07.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    
    public func configure(name: String){
        labelName.text = name
    }
}
