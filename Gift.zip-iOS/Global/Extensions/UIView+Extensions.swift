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
    
    // set popup background
    func setPopupBackgroundView(to superV: UIView) {
        self.backgroundColor = .black
        superV.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superV.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superV.bottomAnchor, constant: 0).isActive = true
        self.leftAnchor.constraint(equalTo: superV.leftAnchor, constant: 0).isActive = true
        self.rightAnchor.constraint(equalTo: superV.rightAnchor, constant: 0).isActive = true
        self.isHidden = true
        self.alpha = 0
        superV.bringSubviewToFront(self)
    }
    
    // animate popup background
    func animatePopupBackground(_ direction: Bool) {
        let duration: TimeInterval = direction ? 0.35 : 0.20
        let alpha: CGFloat = direction ? 0.60 : 0.0
        self.isHidden = !direction
        UIView.animate(withDuration: duration) {
            self.alpha = alpha
        }
    }
    
    
    // animate sticker view
    func animateStickerView(_ direction: Bool) {
        self.superview?.bringSubviewToFront(self)
        let duration: TimeInterval = direction ? 0.25 : 0.10
        let alpha: CGFloat = direction ? 1.0 : 0.0
        self.isHidden = !direction
        UIView.animate(withDuration: duration) {
            self.alpha = alpha
        }
    }
    
    
    // dahsed View
    func makeDashedBorder(_ color: UIColor)  {
        let mViewBorder = CAShapeLayer()
        let opacity: CGFloat = 0.4
        let borderColor: UIColor = color
        mViewBorder.strokeColor = borderColor.withAlphaComponent(opacity).cgColor
        mViewBorder.lineDashPattern = [4, 4]
        mViewBorder.frame = self.bounds
        mViewBorder.fillColor = nil
        mViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        mViewBorder.name = "dash"
        self.layer.addSublayer(mViewBorder)
    }
    
    func eraseBorder() {
        for layer in self.layer.sublayers! {
            if layer.name == "dash" {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    // 특정 모서리만 둥글게
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
