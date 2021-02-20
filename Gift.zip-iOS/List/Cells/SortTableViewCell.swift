//
//  SortTableViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/19.
//

import UIKit

class SortTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSortType: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    public func configure( model : SortModel){
        labelSortType.text = model.sortType
        if model.isSelected {
            imgCheck.image = UIImage(named: "imgCheck")
            labelSortType.font = .boldSystemFont(ofSize: 16)
        }else{
            imgCheck.image = .none
            labelSortType.font = .systemFont(ofSize: 16)
        }
    }

}
