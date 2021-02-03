//
//  ImageCropVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/02.
//
//
import UIKit

class ImageCropVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!

    var image: UIImage!
    var imageView: UIImageView!
    var holeView: UIView!
    var viewFinder: HollowView!

    var holeWidth:CGFloat = 0
    var holeHeight: CGFloat = 0
    var frameOfImage: FrameOfImage = .circle

    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func changeFrameOfImage() {
        switch frameOfImage {
        case .square:
            holeWidth = self.scrollView.frame.width - 49 * 2
            holeHeight = holeWidth

            let holeX = (scrollView.frame.width - holeWidth) / 2
            let holeY = (scrollView.frame.height - holeHeight) / 2 + 107

            let holeRect = CGRect(x: holeX, y: holeY, width: holeWidth, height: holeHeight) // 269
            holeView = UIView.init(frame: holeRect)
            break
        case .circle:
            holeWidth = self.scrollView.frame.width - 49 * 2
            holeHeight = holeWidth

            let holeX = (scrollView.frame.width - holeWidth) / 2
            let holeY = (scrollView.frame.height - holeHeight) / 2 + 107

            let holeRect = CGRect(x: holeX, y: holeY, width: holeWidth, height: holeHeight) // 269
            holeView = UIView.init(frame: holeRect)

            holeView.layer.cornerRadius = holeView.frame.width / 2

            break
        case .windowFrame:
            holeWidth = self.scrollView.frame.width - 49 * 2
            holeHeight = holeWidth

            let holeX = (scrollView.frame.width - holeWidth) / 2
            let holeY = (scrollView.frame.height - holeHeight) / 2 + 107

            let holeRect = CGRect(x: holeX, y: holeY, width: holeWidth, height: holeHeight) // 269
            holeView = UIView.init(frame: holeRect)
            break
        }

    }
    func setupView() {
        changeFrameOfImage()
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

            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.alwaysBounceVertical = true
            scrollView.alwaysBounceHorizontal = true
            scrollView.delegate = self

            let minZoom = max(holeWidth / image.size.width, holeHeight / image.size.height)
            scrollView.minimumZoomScale = minZoom
            scrollView.zoomScale = minZoom
            scrollView.maximumZoomScale = minZoom * 4

//            viewFinder = HollowView(frame: view.frame, transparentRect: holeView)
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

    //MARK: - IBAction

    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func completeCropImage(_ sender: UIButton) {

        // send crop image
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func changeSquareFrame(_ sender: Any) {
        frameOfImage = .square
        changeFrameOfImage()
        viewFinder.removeFromSuperview()
//        viewFinder =  HollowView(frame: view.frame, transparentRect: holeView)
        view.addSubview(viewFinder)
        view.bringSubviewToFront(topBar)
        view.bringSubviewToFront(bottomBar)
    }


    @IBAction func changeCircleFrame(_ sender: Any) {
        frameOfImage = .circle
        changeFrameOfImage()
        viewFinder.removeFromSuperview()
//        viewFinder =  HollowView(frame: view.frame, transparentRect: holeView)
        view.addSubview(viewFinder)
        view.bringSubviewToFront(topBar)
        view.bringSubviewToFront(bottomBar)
    }

    @IBAction func changeToWindowFrame(_ sender: Any) {
        frameOfImage = .windowFrame
        changeFrameOfImage()
        viewFinder.removeFromSuperview()
//        viewFinder =  HollowView(frame: view.frame, transparentRect: holeView)
        view.addSubview(viewFinder)
        view.bringSubviewToFront(topBar)
        view.bringSubviewToFront(bottomBar)
    }
}

// MARK: hollow view class

class HollowView: UIView {
    var transparentRect: CGRect!
    var transparentRect2: CGRect!
    
    init(frame: CGRect, transparentRect1: CGRect, transparentRect2: CGRect) {
        super.init(frame: frame)
        
        self.transparentRect = transparentRect1
        self.transparentRect2 = transparentRect2
        
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
        let holeRectIntersection2 = transparentRect2.intersection(rect)
        UIColor.clear.setFill();
        UIRectFill(holeRectIntersection)
        UIRectFill(holeRectIntersection2)
    }
}





