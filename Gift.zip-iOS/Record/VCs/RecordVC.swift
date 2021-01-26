//
//  RecordVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/26.
//

import UIKit
import RxCocoa
import RxSwift
import PhotosUI

class RecordVC: UIViewController {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    
    let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayouts()
        initTextField()
        initializeDelegates()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - IBAction
    
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

//MARK: - Private Methods

extension RecordVC {
    
    private func setLayouts() {
        
        for button in buttons {
            button.makeRounded(cornerRadius: 12.0)
        }
        
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "이름 입력",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(white: 1.0, alpha: 0.34)]
        )
    }
    
    private func initTextField() {
        
        nameTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe { _ in
                if let text = self.nameTextField.text {
                    if text.isEmpty {
                        self.fromLabel.alpha = 0.34
                    } else {
                        self.fromLabel.alpha = 1
                    }
                }
                self.nameTextField.sizeToFit()
            }.disposed(by: disposeBag)

    }
    
    private func initializeDelegates() {
        nameTextField.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension RecordVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
