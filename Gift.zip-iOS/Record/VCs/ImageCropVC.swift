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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    func setupView() {
        if image.imageOrientation != .up {
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            var rect = CGRect.zero
            rect.size = image.size
            image.draw(in: rect)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        var holeWidth:CGFloat = 0
        var holeHeight: CGFloat = 0
        
        if frameOfImage == . square {
            holeWidth = 275.0
            holeHeight = 275.0
            
            holeRect = CGRect(x: 50, y: 225, width: holeWidth, height: holeHeight)
        }
        
        imageView = UIImageView(image: image)
        scrollView.addSubview(imageView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        
        let minZoom = max(holeWidth / image.size.width, holeHeight / image.size.height)
        scrollView.minimumZoomScale = minZoom
        scrollView.zoomScale = minZoom
        scrollView.maximumZoomScale = minZoom*4
        
        let viewFinder = hollowView(frame: view.frame, transparentRect: holeRect)
        view.addSubview(viewFinder)
        
    }
    
    //MARK: - scrollView delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let gapToHole: CGFloat = (view.frame.height -  147) / 2 - holeRect.height / 2
        scrollView.contentInset = UIEdgeInsets(top: gapToHole, left: 50, bottom: gapToHole, right: 50)
        
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeCropImage(_ sender: UIButton) {
        
        // send crop image
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: hollow view class

class hollowView: UIView {
    var transparentRect: CGRect!
    
    init(frame: CGRect, transparentRect: CGRect) {
        super.init(frame: frame)
        
        self.transparentRect = transparentRect
        self.isUserInteractionEnabled = false
        self.alpha = 0.5
        self.isOpaque = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        backgroundColor?.setFill()
        UIRectFill(rect)
        
        let holeRectIntersection = transparentRect.intersection( rect )
        
        UIColor.clear.setFill();
        UIRectFill(holeRectIntersection);
    }
}





