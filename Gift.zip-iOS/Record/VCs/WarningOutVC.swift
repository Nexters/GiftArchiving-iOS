//
//  WarningOutVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/18.
//

import UIKit

class WarningOutVC: UIViewController {

    @IBOutlet weak var roundView: UIView!
    @IBOutlet var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        roundView.roundCorners(cornerRadius: 8.0, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        for button in buttons {
            button.makeRounded(cornerRadius: 8.0)
        }
        
    }
    @IBAction func dismiss(_ sender: Any) {
        NotificationCenter.default.post(name: .init("goOutToMain"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goOut(_ sender: Any) {
        NotificationCenter.default.post(name: .init("goOutToMain"), object: nil, userInfo: ["cancel": true])
        self.dismiss(animated: true) {
            
        }
    }
}
