//
//  DeleteDetailVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/14.
//

import UIKit

class DeleteDetailVC: UIViewController {
    @IBOutlet weak var roundView: UIView!
    @IBOutlet var buttons: [UIButton]!
    
    var giftId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundView.roundCorners(cornerRadius: 8.0, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        for button in buttons {
            button.makeRounded(cornerRadius: 8.0)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        // 삭제 API
        
        GiftService.shared.deleteGift(giftId: giftId!) { result in
            switch result {
            case .success(let data):
                guard let _ = data as? RecordGiftData else { return }
                
//                showToast(message: "삭제되었습니다.", font: UIFont(name: "AppleSDGothicNeo-Medium", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0))
            case .requestErr(let message):
                guard let message = message as? String else { return }
                let alertViewController = UIAlertController(title: "통신 실패", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertViewController.addAction(action)
                self.present(alertViewController, animated: true, completion: nil)
                
            case .pathErr: print("path")
            case .serverErr:
                let alertViewController = UIAlertController(title: "통신 실패", message: "서버 오류", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertViewController.addAction(action)
                self.present(alertViewController, animated: true, completion: nil)
                print("networkFail")
                print("serverErr")
            case .networkFail:
                let alertViewController = UIAlertController(title: "통신 실패", message: "네트워크 오류", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertViewController.addAction(action)
                self.present(alertViewController, animated: true, completion: nil)
                print("networkFail")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
