//
//  SettingVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/06.
//

import UIKit
import MessageUI
class SettingsVC: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var settingTableView: UITableView!
    
    var serviceSettingsName: [String] = ["현재버전 1.1.0", "기프트집에 대하여"]
    var serviceSettingsIconImageName: [String] = ["icnAppversion", "iconFeeling"]
    
    var userSettingsName: [String] = ["공지사항", "앱 문의・건의"]
    var userSettingsIconImageName: [String] = ["iconAnnouncementCopy", "iconQnAmail"]
    
    var appSettingsName: [String] = ["서비스 이용약관", "오픈 소스 라이센스", "개인정보 이용방침"]
    var appSettingsIconImageName: [String] = ["iconTerms", "iconOpensourceCopy", "iconPrivacyinfo"]
    
    lazy var popupBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNotificationCenter()
        initDelegate()
        initPopupBackgroundView()
    }
    
    @IBAction func popSetting(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(cancelLogoutPopup), name: .init("cancelLogoutPopup"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .init("logout"), object: nil)
            
    }
    
    @objc func logout() {
        popupBackgroundView.animatePopupBackground(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            guard let navivc = self.navigationController else { return }
            print(navivc.viewControllers.count)
            if navivc.viewControllers.count == 4 {
                let main = navivc.viewControllers[navivc.viewControllers.count - 4]
                navivc.popToViewController(main, animated: true)
            } else {
                let main = navivc.viewControllers[navivc.viewControllers.count - 3]
                
                navivc.popToViewController(main, animated: true)
            }
       
            
        }
        
        
    }
    
    @objc func cancelLogoutPopup() {
        popupBackgroundView.animatePopupBackground(false)
    }
    
    private func initPopupBackgroundView() {
        popupBackgroundView.setPopupBackgroundView(to: view)
    }
    
    private func initDelegate() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
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
    
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 3
        } else if section == 2 {
            return 4
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            if indexPath.section == 3 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FooterTVC.identifier, for: indexPath) as? FooterTVC else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTVC.identifier, for: indexPath) as? HeaderTVC else { return UITableViewCell() }
                if indexPath.section == 0 {
                    cell.titleLabel.text = "서비스 설정"
                } else if indexPath.section == 1 {
                    cell.titleLabel.text = "사용자 지원"
                } else {
                    cell.titleLabel.text = "앱 정보"
                }
//                cell.isUserInteractionEnabled = false
                return cell
            }
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.identifier, for: indexPath) as? SettingsTVC else {
                return UITableViewCell()
            }
            
            if indexPath.section == 0 {
                cell.setInformations(settingIconName: serviceSettingsName[indexPath.row-1], settingIconImageName: serviceSettingsIconImageName[indexPath.row-1])
            } else if indexPath.section == 1 {
                cell.setInformations(settingIconName: userSettingsName[indexPath.row-1], settingIconImageName: userSettingsIconImageName[indexPath.row-1])
            } else {
                cell.setInformations(settingIconName: appSettingsName[indexPath.row-1], settingIconImageName: appSettingsIconImageName[indexPath.row-1])
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 168
        } else {
            return 56.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
       
        if indexPath.row == 0 {
            
        } else {
            cell.contentView.backgroundColor = UIColor(red: 29.0 / 255.0, green: 29.0 / 255.0, blue: 32.0 / 255.0, alpha: 1.0)
            if indexPath.section == 1 && indexPath.row == 1 {
                // 공지사항
                guard let vc = self.storyboard?.instantiateViewController(identifier: "NoticeVC") as? NoticeVC else { return }
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.section == 0 && indexPath.row == 2 {
                guard let vc = self.storyboard?.instantiateViewController(identifier: "TeamIntroduceVC") as? TeamIntroduceVC else { return }
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.section == 1 && indexPath.row == 2 {
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
            } else if indexPath.section == 2 {
                guard let vc = self.storyboard?.instantiateViewController(identifier: "TermsVC") as? TermsVC else { return }
                
                switch indexPath.row {
                case 1:
                    // 서비스 이용약관
                    vc.titleText = "기프트집 서비스 이용약관"
                    vc.navigationTitleText = "서비스 이용약관"
                    break
                case 2:
                    vc.titleText = "기프트집 오픈소스 라이센스"
                    vc.navigationTitleText = "오픈소스 라이센스"
                    break
                case 3:
                    vc.titleText = "기프트집 사용자\n개인정보 이용방침"
                    vc.navigationTitleText = "개인정보 이용방침"
                    break
                default:
                    break
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 0
        } else if section == 2 {
            return 0
        } else {
            return 16.0
        }
        
    }
    
}

extension SettingsVC: UITableViewButtonSelectedDelegate {
    func logoutButtonPressed() {
        popupBackgroundView.animatePopupBackground(true)
        guard let popup = self.storyboard?.instantiateViewController(identifier: "LogoutPopupVC") as? LogoutPopupVC else { return }
        
        popup.modalPresentationStyle = .overFullScreen
        
        present(popup, animated: true, completion: nil)
    }
    
    func sendMailButtonPressed() {
      
    }
}

protocol UITableViewButtonSelectedDelegate: class {
    func logoutButtonPressed()
    
    func sendMailButtonPressed()
}

extension UITableViewButtonSelectedDelegate {
    func logoutButtonPressed() {}
    
    func sendMailButtonPressed() {}
}
