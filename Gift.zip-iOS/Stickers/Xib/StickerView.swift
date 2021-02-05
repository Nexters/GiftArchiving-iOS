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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @IBAction func selectSingle(_ sender: UIButton) {
        moveHighLightBar(to: sender)
        singleSticker.alpha = 1
        packageSticker.alpha = 0.3
    }
    @IBAction func selectPackage(_ sender: UIButton) {
        moveHighLightBar(to: sender)
        singleSticker.alpha = 0.3
        packageSticker.alpha = 1
        
    }
    
    
    private func moveHighLightBar(to button: UIButton) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: {
            // Slide Animation
            self.slider.frame.origin.x =  button.frame.minX
        }) { _ in
        }
    }
    
    
    private func initCollectionView() {
        let nib = UINib(nibName: SingleStickerCVC.identifier, bundle: nil)
        stickerCollectionView.register(nib, forCellWithReuseIdentifier: SingleStickerCVC.identifier)
        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
    }
    
}

extension StickerView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let singleSticker = collectionView.dequeueReusableCell(withReuseIdentifier: SingleStickerCVC.identifier, for: indexPath) as? SingleStickerCVC else { return UICollectionViewCell() }
        return singleSticker
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = self.frame.height - 53
        return CGSize(width: self.frame.width, height: cellHeight)
    }
    
    
}
