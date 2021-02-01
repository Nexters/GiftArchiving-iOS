//
//  ImageCropVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/02.
//

import UIKit

class ImageCropVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage!
    var imageView: UIImageView!
    var frameOfImage: FrameOfImage = .square
    var holeRect: CGRect!
    
    func setupView() {
        if image.imageOrientation != .up {
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            var rect = CGRect.zero
            rect.size = image.size
            image.draw(in: rect)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        
        if frameOfImage == . square {
            let holeWidth = 275.0
            let holeHeight = 275.0
            
            holeRect = CGRect(x: 0, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        }
    }
}
