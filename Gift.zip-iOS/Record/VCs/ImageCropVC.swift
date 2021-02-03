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
    var widthAndHeightOfImage: CGFloat = 0.0
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        var holeWidth:CGFloat = 0
        var holeHeight: CGFloat = 0
        switch frameOfImage {
        case .square:
            holeWidth = self.scrollView.frame.width - 49 * 2
            holeHeight = holeWidth
            
            let holeX = (scrollView.frame.width - holeWidth) / 2
            let holeY = (scrollView.frame.height - holeHeight) / 2 + 107
            
            holeRect = CGRect(x: holeX, y: holeY, width: holeWidth, height: holeHeight) // 269
        case .circle:
            holeWidth = self.scrollView.frame.width - 49 * 2
            holeHeight = holeWidth
            
            let holeX = (scrollView.frame.width - holeWidth) / 2
            let holeY = (scrollView.frame.height - holeHeight) / 2 + 107
            
            holeRect = CGRect(x: holeX, y: holeY, width: holeWidth, height: holeHeight) // 269
            break
        case .windowFrame:
            holeWidth = self.scrollView.frame.width - 49 * 2
            holeHeight = holeWidth
            
            let holeX = (scrollView.frame.width - holeWidth) / 2
            let holeY = (scrollView.frame.height - holeHeight) / 2 + 107
            
            holeRect = CGRect(x: holeX, y: holeY, width: holeWidth, height: holeHeight) // 269
            break
        }
        if image == nil {
            
        } else {
            if image.imageOrientation != .up {
                UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
                var rect = CGRect.zero
                rect.size = image.size
                image.draw(in: rect)
                image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            imageView = UIImageView(image: image)
            scrollView.addSubview(imageView)
            print(imageView.frame)
            print(imageView.bounds)
            print("scrollView.frame: \(scrollView.frame)")
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.alwaysBounceVertical = true
            scrollView.alwaysBounceHorizontal = true
            scrollView.delegate = self
            
            let minZoom = max(holeWidth / image.size.width, holeHeight / image.size.height)
            scrollView.minimumZoomScale = minZoom
            scrollView.zoomScale = minZoom
            scrollView.maximumZoomScale = minZoom * 4
            
            let viewFinder = hollowView(frame: view.frame, transparentRect: holeRect)
            view.addSubview(viewFinder)
            view.bringSubviewToFront(topBar)
            view.bringSubviewToFront(bottomBar)
            
        }
        
    }
    
    //MARK: - scrollView delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let gapToHole: CGFloat = (scrollView.frame.height - (scrollView.frame.width - 98)) / 2
        
        print("gapToHole\(gapToHole)")
        // TODO: scroll 영역 설정하는 곳
        scrollView.contentInset = UIEdgeInsets(top: gapToHole, left: 49, bottom: gapToHole, right: 49)
        
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
    var transparentRect: UIView!
    
    init(frame: CGRect, transparentRect: CGRect) {
        super.init(frame: frame)
        
        self.transparentRect = UIView.init(frame: transparentRect)
      
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
        
        let holeRectIntersection = transparentRect.frame.intersection( rect )
        
        UIColor.clear.setFill();
        UIRectFill(holeRectIntersection);
    }
}





