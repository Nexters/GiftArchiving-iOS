//
//  DetailVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/14.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var upperContainer: UIView!
    
    @IBOutlet var tagButtons: [UIButton]!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var purposeImageView: UIImageView!
    @IBOutlet weak var feelingImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for btn in tagButtons {
            btn.makeRounded(cornerRadius: 8.0)
        }

    }
    
    @IBAction func dismissDetail(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func moreButtonTapped(_ sender: Any) {
    }
}
