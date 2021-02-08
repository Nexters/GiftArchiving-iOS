//
//  ShareVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/08.
//

import UIKit

class ShareVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func popToMain(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
        
    }
}
