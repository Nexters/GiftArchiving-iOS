//
//  UIView+Extensions.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/25.
//

import UIKit

extension UIView {
    
    // Set Rounded View
    func makeRounded(cornerRadius : CGFloat?){
        
        // UIView 의 모서리가 둥근 정도를 설정
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            // cornerRadius 가 nil 일 경우의 default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        
        self.layer.masksToBounds = true
    }
    
}
