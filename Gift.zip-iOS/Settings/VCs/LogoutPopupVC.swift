//
//  LogoutPopupVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/08.
//

import UIKit

class LogoutPopupVC: UIViewController {
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var roundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundView.roundCorners(cornerRadius: 8.0, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        for button in buttons {
            button.makeRounded(cornerRadius: 8.0)
        }
        
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: .init("cancelLogoutPopup"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: "appleId")
        userDefault.removeObject(forKey: "kakaoId")
        
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .init("logout"), object: nil)
        }
    }
}
