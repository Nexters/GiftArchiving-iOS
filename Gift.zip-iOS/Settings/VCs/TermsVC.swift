//
//  TermsVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/08.
//

import UIKit

class TermsVC: UIViewController {
    
    
    
    @IBOutlet weak var navigaitonTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var navigationTitleText: String?
    var titleText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        navigaitonTitleLabel.text = navigationTitleText
        titleLabel.text = titleText
        if navigationTitleText == "서비스 이용약관" {
            imageView.image = UIImage.init(named: "1")
        } else if navigationTitleText == "개인정보 이용방침" {
            imageView.image = UIImage.init(named: "invalidName")
        } else {
            imageView.image = UIImage.init(named: "2")
        }
        
    }
    
    @IBAction func popView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
