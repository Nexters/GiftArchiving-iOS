//
//  CategoryPopupVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/04.
//

import UIKit

class IconPopupVC: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var safeAreaView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var popupViewHeight: NSLayoutConstraint!
    
    var whichPopup: Int = 0
    // 0 :
    
    var backgroundColor: UIColor?
    
    var popupViewHeightByPhones: CGFloat?
    
    weak var delegate: PopupViewDelegate?
    
    var isSend: Bool = false
    
    let categoryImageArray: [String] = ["icDigital", "icGroceries", "icLiving", "icPet", "icBaby", "icGiftCard", "icSports", "icFashion"]
    let categoryNameArray: [String] = ["디지털", "식품", "리빙", "펫", "유아동", "상품권", "스포츠", "패션"]
    let purposeImageArray: [String] = ["icBirthday", "icAnniversary", "icWedding", "icGetajob", "icHoliday", "icGraduation", "icApology", "icAppreciation"]
    let purposeNameArray: [String] = ["생일", "기념일", "결혼", "취업", "명절", "졸업", "사과", "감사"]
    
    
    
    let categoryImageArray2: [String] = ["icCosmetic", "icMcoupon", "icCulture", "icEtc"]
    let categoryNameArray2: [String] = ["화장품", "모바일교환권", "컬처", "기타"]
    let purposeImageArray2: [String] = ["icCheer", "icHousewarming", "icJust", "icEtc"]
    let purposeNameArray2: [String] = ["응원", "집들이", "그냥", "기타"]
    
    let emotionImageSendArray: [String] = ["icEmojiCheer", "icEmojiSorry", "icEmojiBest", "icEmojiCelebration"]
    let emotionNameSendArray: [String] = ["응원해", "미안해", "나최고지", "축하해"]
    let emotionImageGetArray: [String] = ["icEmojiSense", "icEmojiLove", "icEmojiTouch", "icEmojiSurprisal"]
    let emotionNameGetArray: [String] = ["센스최고", "사랑해", "감동이야", "놀라워"]
    
    
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
        iconCollectionView.isPagingEnabled = true
        if whichPopup == 2 {
            pageControl.numberOfPages = 1
        } else {
            pageControl.numberOfPages = 2
        }
        pageControl.hidesForSinglePage = true
    }
    
    private func initDelegates() {
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
    }
    
    @IBAction func selectCategory(_ sender: Any) {
        NotificationCenter.default.post(name: .init("selectIcon"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

extension IconPopupVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if whichPopup == 2 {
            return 1
        } else {
            return 2
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if whichPopup == 2 {
            guard let icon = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySecondCVC.identifier, for: indexPath) as? CategorySecondCVC else {
                return UICollectionViewCell()
            }
            icon.setBorder()
            if isSend {
                icon.setCategories(iconNames: emotionNameSendArray, iconImages: emotionImageSendArray)
                icon.iconKind = "emotion"
                
            } else {
                icon.setCategories(iconNames: emotionNameGetArray, iconImages: emotionImageGetArray)
                icon.iconKind = "emotion"
            }
            
            icon.delegate = self
            return icon
            
        } else {
            if indexPath.item == 0 {
                guard let icon = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCVC.identifier, for: indexPath) as? CategoryCVC else {
                    return UICollectionViewCell()
                }
                icon.setBorder()
                if whichPopup == 0 {
                    icon.setCategories(iconNames: categoryNameArray, iconImages: categoryImageArray)
                    icon.iconKind = "category"
                } else if whichPopup == 1 {
                    icon.setCategories(iconNames: purposeNameArray, iconImages: purposeImageArray)
                    icon.iconKind = "purpose"
                } else {
                    
                }
                
                icon.delegate = self
                return icon
            } else {
                guard let icon = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySecondCVC.identifier, for: indexPath) as? CategorySecondCVC else {
                    return UICollectionViewCell()
                }
                icon.setBorder()
                if whichPopup == 0 {
                    icon.setCategories(iconNames: categoryNameArray2, iconImages: categoryImageArray2)
                    icon.iconKind = "category"
                } else if whichPopup == 1 {
                    icon.setCategories(iconNames: purposeNameArray2, iconImages: purposeImageArray2)
                    icon.iconKind = "purpose"
                } else {
                    
                }
                
                icon.delegate = self
                return icon
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: popupViewHeightByPhones! - 58)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageSide = self.view.frame.width
        
        let offset = scrollView.contentOffset.x
        
        let currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        pageControl.currentPage = currentPage
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
}

extension IconPopupVC: CollectionViewButtonSelectedProtocol {
    
    func iconSelectedAndDismissView(index: Int, from: Int, iconKind: String) {
        if iconKind == "category"  {
            if from == 1 {
                NotificationCenter.default.post(name: .init("selectIcon"), object: nil, userInfo: ["iconImageName": categoryImageArray[index], "iconName": categoryNameArray[index], "iconKind": iconKind])
            } else {
                NotificationCenter.default.post(name: .init("selectIcon"), object: nil, userInfo: ["iconImageName": categoryImageArray2[index], "iconName": categoryNameArray2[index], "iconKind": iconKind])
            }
        } else if iconKind == "purpose" {
            if from == 1 {
                NotificationCenter.default.post(name: .init("selectIcon"), object: nil, userInfo: ["iconImageName": purposeImageArray[index], "iconName": purposeNameArray[index], "iconKind": iconKind])
            } else {
                NotificationCenter.default.post(name: .init("selectIcon"), object: nil, userInfo: ["iconImageName": purposeImageArray2[index], "iconName": purposeNameArray2[index], "iconKind": iconKind])
            }
        } else if iconKind == "emotion" {
            if isSend {
                NotificationCenter.default.post(name: .init("selectIcon"), object: nil, userInfo: ["iconImageName": emotionImageSendArray[index], "iconName": emotionNameSendArray[index], "iconKind": iconKind])
                
            } else {
                NotificationCenter.default.post(name: .init("selectIcon"), object: nil, userInfo: ["iconImageName": emotionImageGetArray[index], "iconName": emotionNameGetArray[index], "iconKind": iconKind])
                
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
