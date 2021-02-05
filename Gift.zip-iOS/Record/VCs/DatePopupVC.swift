//
//  datePopupVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/26.
//

import UIKit

class DatePopupVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var backgroundColorViews: [UIView]!
    
    weak var delegate: PopupViewDelegate?
    
    var currentBackgroundColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayouts()
        setBackgroundColor()
    }
    
    private func setLayouts() {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
    }
    
    private func setBackgroundColor() {
        for v in backgroundColorViews {
            v.backgroundColor = currentBackgroundColor
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        delegate?.sendDateButtonTapped(nil)
    }
    
    @IBAction func changeDate(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        delegate?.sendDateButtonTapped(datePicker.date)
    }
    
    
}
