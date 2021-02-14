//
//  ListCollectionViewCell.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/02.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    public func configure(with model: LoadGiftData, color : UIColor){
        if let encoded = model.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encoded) {
            
            DispatchQueue.global().async {
                do{
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.imgView.image = UIImage(data: data)
                    }
                }catch(let err){
                    debugPrint(err.localizedDescription)
                }
            }
        }
        
        self.labelName.text = model.name
        self.labelDate.text = model.receiveDate
        self.backgroundColor = color
        if color == UIColor(named: "wheat") {
            labelName.textColor = UIColor.greyishBrown
            labelDate.textColor = UIColor.greyishBrownOpacity
        }else{
            labelName.textColor = UIColor.white
            labelDate.textColor = UIColor.whiteOpacity
        }
       
        
        
    }
}
