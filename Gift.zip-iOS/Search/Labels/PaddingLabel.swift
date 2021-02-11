//
//  PaddingLabel.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/07.
//

import UIKit

class PaddingLabel: UILabel {

   @IBInspectable var topInset: CGFloat = 6.0
   @IBInspectable var bottomInset: CGFloat = 6.0
   @IBInspectable var leftInset: CGFloat = 12.0
   @IBInspectable var rightInset: CGFloat = 12.0

   override func drawText(in rect: CGRect) {
      let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
      super.drawText(in: rect.inset(by: insets))
   }

   override var intrinsicContentSize: CGSize {
      get {
         var contentSize = super.intrinsicContentSize
         contentSize.height += topInset + bottomInset
         contentSize.width += leftInset + rightInset
         return contentSize
      }
   }
}
