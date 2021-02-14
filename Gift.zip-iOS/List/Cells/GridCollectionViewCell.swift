//
//  GridCollectionViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/04.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    public func configure(with model: LoadGiftData, color : UIColor){
        if let encoded = model.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encoded) {
            
            DispatchQueue.global().async {
                do{
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.imgVIew.image = UIImage(data: data)
                    }
                }catch(let err){
                    debugPrint(err.localizedDescription)
                }
            }
        }
    
        self.labelName.text = model.name
        self.labelDate.text = model.receiveDate
        self.backView.backgroundColor = color
        self.labelDate.textColor = UIColor.whiteOpacity
    
        
    }
    
}
