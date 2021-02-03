//
//  CategoryPopupVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/04.
//

import UIKit

class CategoryPopupVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var safeAreaView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var backgroundColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }
    
    private func setLayout() {
        if let bc = backgroundColor {
            backgroundView.backgroundColor = bc
            safeAreaView.backgroundColor = bc
        }
        
    }
}
