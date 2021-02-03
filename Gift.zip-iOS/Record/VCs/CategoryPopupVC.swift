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
    @IBOutlet weak var popupViewHeight: NSLayoutConstraint!
    
    var backgroundColor: UIColor?
    
    var popupViewHeightByPhones: CGFloat?
    weak var delegate: PopupViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        initDelegates()
    }
    
    private func setLayout() {
        if let bc = backgroundColor, let height = popupViewHeightByPhones {
            backgroundView.backgroundColor = bc
            safeAreaView.backgroundColor = bc
            popupViewHeight.constant = height
        }
    }
    
    private func initDelegates() {
        categoryCollectionView.delegate = self
    }
    
    @IBAction func selectCategory(_ sender: Any) {
//        delegate?.sendIconDataButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
}

extension CategoryPopupVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
    
}
