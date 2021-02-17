//
//  DetailMoreVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/14.
//

import UIKit

class DetailMoreVC: UIViewController {

    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var currentBackgroundColor: String = "charcoalGrey"
    override func viewDidLoad() {
        super.viewDidLoad()
//        roundView.backgroundColor = UIColor.init(named:currentBackgroundColor)
        roundView.roundCorners(cornerRadius: 8.0, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        cancelButton.makeRounded(cornerRadius: 8.0)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .init("popupchange"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
