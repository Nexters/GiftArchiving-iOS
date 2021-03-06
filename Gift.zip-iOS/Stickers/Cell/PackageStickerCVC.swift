//
//  PackageStickerCVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/06.
//

import UIKit

class PackageStickerCVC: UICollectionViewCell {
    static let identifier: String = "PackageStickerCVC"
    
    @IBOutlet weak var packageCollectionView: UICollectionView!
    
    
    var currentBackgroundColor: UIColor = UIColor.Background.charcoalGrey.popup {
        didSet {
            packageCollectionView.backgroundColor = currentBackgroundColor
        }
    }
    
    var stickers: [[String]] = {
        var heart: [String] = []
        for i in 0..<12 {
            heart.append("heart_package_sticker_\(i+1)")
        }
        var diary: [String] = []
        for i in 0..<42 {
            diary.append("diary_package_sticker_\(i+1)")
        }
        
        return [heart, diary]
    }()
    
    var stickerPackage: [String] = ["heartPackageSticker","heartDiarySticker"]
    
    private var currentIndex: Int = 0
    
    var isPackageSelected: Bool = false {
        didSet {
            if isPackageSelected {
                if let layout = packageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .vertical
                }
            } else {
                if let layout = packageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                }
            }
            packageCollectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isPackageSelected = false
        
        let nib = UINib(nibName: PackageCVC.identifier, bundle: nil)
        packageCollectionView.register(nib, forCellWithReuseIdentifier: PackageCVC.identifier)
        packageCollectionView.delegate = self
        packageCollectionView.dataSource = self
        
        let nib1 = UINib(nibName: PackageCategoryCVC.identifier, bundle: nil)
        packageCollectionView.register(nib1, forCellWithReuseIdentifier: PackageCategoryCVC.identifier)
        
        
        let nib2 = UINib(nibName: UpdateCVC.identifier, bundle: nil)
        packageCollectionView.register(nib2, forCellWithReuseIdentifier: UpdateCVC.identifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectPackageCategory), name: .init("selectPackageCategory"), object: nil)
    }

    @objc func selectPackageCategory(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let index = userInfo["index"] as? Int else { return }
        
        currentIndex = index
        isPackageSelected = true
    }
}


extension PackageStickerCVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isPackageSelected {
            return stickers[currentIndex].count
        } else {
            return stickerPackage.count + 1
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isPackageSelected {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PackageCVC.identifier, for: indexPath) as? PackageCVC else { return UICollectionViewCell() }
            
            cell.setSticker(imageName: stickers[currentIndex][indexPath.item])
            return cell
        } else {
            if indexPath.item == stickerPackage.count {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpdateCVC.identifier, for: indexPath) as? UpdateCVC else { return UICollectionViewCell() }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PackageCategoryCVC.identifier, for: indexPath) as? PackageCategoryCVC else { return UICollectionViewCell() }
                cell.setSticker(imageName: stickerPackage[indexPath.item])
                cell.index = indexPath.item
                return cell
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if isPackageSelected {
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        } else {
            return UIEdgeInsets(top: 30, left: 32, bottom: 72, right: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isPackageSelected {
            return CGSize(width: 60, height: 60)
        } else {
            let width: CGFloat = 120
            let height: CGFloat = width * 136 / 104
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if isPackageSelected {
            let spacing: CGFloat = (collectionView.frame.width - 300) / 3
            return spacing
        } else {
            return 25
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
}
