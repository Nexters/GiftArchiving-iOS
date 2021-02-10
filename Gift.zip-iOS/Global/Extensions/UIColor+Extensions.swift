//
//  UIColor+Extensions.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/26.
//

import UIKit

extension UIColor {
    
    @nonobjc class var wheat: UIColor {
        return UIColor(red: 1.0, green: 208.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var pinkishOrange: UIColor {
        return UIColor(red: 1.0, green: 114.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var ceruleanBlue: UIColor {
        return UIColor(red: 16.0 / 255.0, green: 103.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0)
      }

    @nonobjc class var charcoalGrey: UIColor {
        return UIColor(red: 44.0 / 255.0, green: 42.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var greyishBrown: UIColor {
        return UIColor(white: 62.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var whiteOpacity: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.4)
    }
    
    @nonobjc class var greyishBrownOpacity: UIColor {
        return UIColor(white: 62.0 / 255.0, alpha: 0.4)
    }
    
    @nonobjc class var midGrey: UIColor {
        return UIColor(white: 57.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var macaroniAndCheese: UIColor {
        return UIColor(red: 221.0 / 255.0, green: 169.0 / 255.0, blue: 66.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var terraCotta: UIColor {
        return UIColor(red: 213.0 / 255.0, green: 90.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var midBlue: UIColor {
        return UIColor(red: 28.0 / 255.0, green: 89.0 / 255.0, blue: 172.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var charcoalGreyTwo: UIColor {
        return UIColor(red: 67.0 / 255.0, green: 67.0 / 255.0, blue: 72.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var charcoalGreyThree: UIColor {
        return UIColor(red: 47.0 / 255.0, green: 47.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var colorTagClicked: UIColor {
        return UIColor(red: 29.0 / 255.0, green: 29.0 / 255.0, blue: 32.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var secondary400: UIColor {
        return UIColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var steel: UIColor {
        return UIColor(red: 142.0 / 255.0, green: 142.0 / 255.0, blue: 155.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var primary400: UIColor {
        return UIColor(white: 41.0 / 255.0, alpha: 1.0)
    }
    enum Background {
        enum charcoalGrey {
            static let `default`: UIColor = .charcoalGrey
            static let popup: UIColor = .midGrey
        }
        
        enum wheat {
            static let `default`: UIColor = .charcoalGrey
            static let popup: UIColor = .macaroniAndCheese
        }
        
        enum pinkishOrange {
            static let `default`: UIColor = .pinkishOrange
            static let popup: UIColor = .terraCotta
        }
        
        enum ceruleanBlue {
            static let `default`: UIColor = .ceruleanBlue
            static let popup: UIColor = .midBlue
        }
    }
    
}
