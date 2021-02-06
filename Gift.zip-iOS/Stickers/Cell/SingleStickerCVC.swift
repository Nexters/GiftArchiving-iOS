//
//  SingleStickerCVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/06.
//

import UIKit

class SingleStickerCVC: UICollectionViewCell {
    static let identifier: String = "SingleStickerCVC"
    @IBOutlet weak var singleCollectionView: UICollectionView!
    
    var currentBackgroundColor: UIColor = UIColor.Background.charcoalGrey.popup {
        didSet {
            singleCollectionView.backgroundColor = currentBackgroundColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: SingleCVC.identifier, bundle: nil)
        singleCollectionView.register(nib, forCellWithReuseIdentifier: SingleCVC.identifier)
        singleCollectionView.delegate = self
        singleCollectionView.dataSource = self
    }

}

extension SingleStickerCVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleCVC.identifier, for: indexPath) as? SingleCVC else { return UICollectionViewCell() }
        
        cell.setSticker(imageName: "searchIllustError")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let spacing: CGFloat = (collectionView.frame.width - 300) / 3
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
}
