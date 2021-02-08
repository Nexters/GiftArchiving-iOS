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
    
    var navigationTitleText: String?
    var titleText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigaitonTitleLabel.text = navigationTitleText
        titleLabel.text = titleText
    }
    
    @IBAction func popView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
