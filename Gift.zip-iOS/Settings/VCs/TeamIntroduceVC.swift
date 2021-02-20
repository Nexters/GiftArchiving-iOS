//
//  TeamIntroduceVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/20.
//

import UIKit
import MessageUI

class TeamIntroduceVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var reddishView: [UIView]!
    @IBOutlet var wheatView: [UIView]!
    @IBOutlet var blueView: [UIView]!
    @IBOutlet var blackView: [UIView]!
    @IBOutlet weak var button: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        button.makeRounded(cornerRadius: 8.0)
        for v in reddishView {
            let radius = v.frame.height / 2
            v.makeRounded(cornerRadius: radius)
        }
        
        for v in blueView {
            let radius = v.frame.height / 2
            v.roundCorners(cornerRadius: radius, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        
        for v in blackView {
            let radius = v.frame.height / 2
            v.makeRounded(cornerRadius: radius)
        }
    }
    
    private func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
//        mailComposerVC.view.backgroundColor = .black
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setSubject("문의 및 건의하기")
        mailComposerVC.setToRecipients(["smile5602@naver.com"])
        mailComposerVC.setMessageBody("- 정확한 문의 파악을 위해 아래 정보를 작성해주세요!\n\n\n1. 문의 내용:\n\n2. 기프트집(카카오) 메일계정: \n\n★ 문의 관련 스크린샷을 첨부하시면 \n 보다 정확하고 빠른 확인이 가능합니다.", isHTML: false)
        return mailComposerVC
    }
    
    private func showSendMailErrorAlert() {
        
        let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        sendMailErrorAlert.addAction(cancelButton)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func popView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToMail(_ sender: Any) {
        // 메일
        let mailComposeViewController = self.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            mailComposeViewController.view.backgroundColor = .black
            mailComposeViewController.navigationController?.navigationBar.tintColor = UIColor.white
            self.present(mailComposeViewController, animated: true, completion: nil)
            print("can send mail")
        } else {
            self.showSendMailErrorAlert()
        }
    }
}
