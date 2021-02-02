//
//  StickyCellFlowLayout.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/03.
//

import UIKit

class StickyCellFlowLayout:UICollectionViewFlowLayout {
    
    var stickyIndexPath = [IndexPath(row: 0, section: 0)]
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // Helpers
        var newLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for layoutAttributesSet in layoutAttributes {
            if let _ = stickyIndexPath.filter({ indexPath -> Bool in
                return indexPath == layoutAttributesSet.indexPath
            }).first {
                continue
            }
            
            if layoutAttributesSet.representedElementCategory == .cell {
                // Add Layout Attributes
                newLayoutAttributes.append(layoutAttributesSet)
            }
        }
        for indexPath in stickyIndexPath {
            if let attr = layoutAttributesForItem(at: indexPath) {
                newLayoutAttributes.append(attr)
            }
        }
        return newLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        guard let attr = super.layoutAttributesForItem(at: indexPath) else { return nil }
        if let _ = stickyIndexPath.filter({ sIndexPath -> Bool in
            return indexPath == sIndexPath
        }).first {
            attr.zIndex += 10
            if attr.frame.origin.y < collectionView.contentOffset.y {
                
                attr.frame.origin.y = collectionView.contentOffset.y
                let tmp = Int(collectionView.contentOffset.y) % (Int(attr.bounds.height) + 20)
                let scale : CGFloat = 1 - (CGFloat(tmp) / attr.bounds.height) * 0.15
                attr.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        return attr
    }
}
