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
    
    @IBOutlet var lineViews: [UIView]!
    var currentBackgroundColor: String = "charcoalGrey"
    override func viewDidLoad() {
        super.viewDidLoad()

        roundView.roundCorners(cornerRadius: 8.0, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        cancelButton.makeRounded(cornerRadius: 8.0)
        for line in lineViews {
            line.backgroundColor = UIColor.secondary300
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .init("editGift"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .init("popupchange"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .init("shareGift"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
