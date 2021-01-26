//
//  RecordVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/26.
//

import UIKit

class RecordVC: UIViewController {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backToMain(_ sender: UIButton) {
        
    }
    
    @IBAction func showDatePicker(_ sender: UIButton) {
        
    }
    
    @IBAction func completeRecord(_ sender: UIButton) {
    }
    
    @IBAction func chooseType(_ sender: UIButton) {
    }
    
    @IBAction func chooseWhen(_ sender: UIButton) {
    }
    
    @IBAction func chooseEmotion(_ sender: UIButton) {
    }
    
}
