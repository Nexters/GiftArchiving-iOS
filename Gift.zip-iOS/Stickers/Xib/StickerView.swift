//
//  StickerView.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/04.
//

import UIKit

class StickerView: XibView {
    
    @IBOutlet weak var singleSticker: UIButton!
    @IBOutlet weak var packageSticker: UIButton!
    @IBOutlet weak var slider: UIView!
    @IBOutlet weak var stickerCollectionView: UICollectionView!
    
    @IBOutlet var backgroundColorViews: [UIView]!
    
    var outsideBackgroundColor: UIColor? {
        didSet {
            switch outsideBackgroundColor! {
            case .charcoalGrey:
                currentBackgroundColor = UIColor.Background.charcoalGrey.popup
                break
            case .ceruleanBlue:
                currentBackgroundColor = UIColor.Background.ceruleanBlue.popup
                break
            case .pinkishOrange:
                currentBackgroundColor = UIColor.Background.pinkishOrange.popup
                break
            case .wheat:
                currentBackgroundColor = UIColor.Background.wheat.popup
                break
            default:
                break
            }
            
        }
    }
    
    private var currentBackgroundColor: UIColor = UIColor.Background.charcoalGrey.popup {
        didSet {
            for v in backgroundColorViews {
                v.backgroundColor = currentBackgroundColor
            }
            stickerCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCollectionView()
        initBackgroundColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @IBAction func selectSingle(_ sender: UIButton) {
        moveHighLightBar(to: sender)
        singleSticker.alpha = 1
        packageSticker.alpha = 0.3
        scrollDirection(by: 0)
    }
    
    @IBAction func selectPackage(_ sender: UIButton) {
        moveHighLightBar(to: sender)
        packageSticker.alpha = 1
        singleSticker.alpha = 0.3
        scrollDirection(by: 1)
    }
    
    
    private func moveHighLightBar(to button: UIButton) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: {
            // Slide Animation
            self.slider.frame.origin.x =  button.frame.minX
            
        }) { _ in
        }
    }
    
    private func initBackgroundColor() {
        
       
    }
    
    private func scrollDirection(by direction: Int) {
        if (direction == 0) {
            let rect = self.stickerCollectionView.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame
            self.stickerCollectionView.scrollRectToVisible(rect!, animated: true)
            
        } else {
            let rect = self.stickerCollectionView.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame
            self.stickerCollectionView.scrollRectToVisible(rect!, animated: true)
            
        }
        
        
    }
    
    private func initCollectionView() {
        let singleNib = UINib(nibName: SingleStickerCVC.identifier, bundle: nil)
        stickerCollectionView.register(singleNib, forCellWithReuseIdentifier: SingleStickerCVC.identifier)
        let packageNib = UINib(nibName: PackageStickerCVC.identifier, bundle: nil)
        stickerCollectionView.register(packageNib, forCellWithReuseIdentifier: PackageStickerCVC.identifier)
        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
        stickerCollectionView.isPagingEnabled = true
        stickerCollectionView.showsHorizontalScrollIndicator = false
    }
    
}

extension StickerView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            print(indexPath.item)
            guard let singleSticker = collectionView.dequeueReusableCell(withReuseIdentifier: SingleStickerCVC.identifier, for: indexPath) as? SingleStickerCVC else { return UICollectionViewCell() }
            singleSticker.backgroundColor = currentBackgroundColor
            print("singleSticker.currentBackgroundColor = currentBackgroundColor")
            singleSticker.currentBackgroundColor = currentBackgroundColor
            return singleSticker
        } else if indexPath.item == 1 {
            print(indexPath.item)
            guard let packageSticker = collectionView.dequeueReusableCell(withReuseIdentifier: PackageStickerCVC.identifier, for: indexPath) as? PackageStickerCVC else { return UICollectionViewCell() }
            packageSticker.backgroundColor = currentBackgroundColor
            packageSticker.backgroundColor = currentBackgroundColor
            return packageSticker
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = self.frame.height - 53
        return CGSize(width: self.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
