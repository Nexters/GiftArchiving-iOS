//
//  datePopupVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/26.
//

import UIKit

class DatePopupVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: PopupViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayouts()
    }
    
    private func setLayouts() {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        delegate?.sendDateButtonTapped(datePicker.date)
    }
}
