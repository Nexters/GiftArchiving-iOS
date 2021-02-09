//
//  AutoTableViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/09.
//

import UIKit

class AutoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    public func configure(label: String, keyword: String){
        labelName.text = label
        labelName.textColor = UIColor.steel
        labelName.attributedText = nil
        let s = label as NSString
        let att = NSMutableAttributedString(string: s as String)
        let r = s.range(of: keyword, options: .regularExpression, range: NSMakeRange(0,s.length))
        print(r.lowerBound)
        print(r.upperBound)
        if r.length > 0 {
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: r)
            att.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16),  range: r)
            labelName.attributedText = att
        }
        
    }
    
}
