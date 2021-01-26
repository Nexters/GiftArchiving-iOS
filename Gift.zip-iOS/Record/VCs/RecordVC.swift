//
//  RecordVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/26.
//

import UIKit
import RxCocoa
import RxSwift

class RecordVC: UIViewController {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var cropImageView: UIImageView!
    
    
    lazy var picker = UIImagePickerController()
    
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
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "사진 선택", message: "되라제발", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func changeFrame(_ sender: UIButton) {
    }
    
    @IBAction func useSticker(_ sender: UIButton) {
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
        picker.delegate = self
    }
    
    
    private func openLibrary() {
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
        
    }
    
}

//MARK: - UITextFieldDelegate

extension RecordVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RecordVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            print(image)
            self.cropImageView.image = image
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
    @objc func savedImage(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        if let error = error {
            print(error)
            return
        }
        print("success")
    }
}
