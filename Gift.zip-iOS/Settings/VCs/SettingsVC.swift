//
//  SettingVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/06.
//

import UIKit

class SettingsVC: UIViewController {
    @IBOutlet weak var settingTableView: UITableView!
    
    var serviceSettingsName: [String] = ["현재버전 1.1.0"]
    var serviceSettingsIconImageName: [String] = ["icnAppversion"]
    
    var userSettingsName: [String] = ["공지사항", "앱 문의・건의"]
    var userSettingsIconImageName: [String] = ["iconAnnouncementCopy", "iconQnAmail"]
    
    var appSettingsName: [String] = ["서비스 이용약관", "오픈 소스 라이센스", "개인정보 이용방침"]
    var appSettingsIconImageName: [String] = ["iconTerms", "iconOpensourceCopy", "iconPrivacyinfo"]
    
    lazy var popupBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        initNotificationCenter()
        initDelegate()
        initPopupBackgroundView()
    }
    
    @IBAction func popSetting(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initTableView() {
        settingTableView.separatorColor = UIColor.init(red: 29, green: 29, blue: 33, alpha: 1)
    }
    
    private func initNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(cancelLogoutPopup), name: .init("cancelLogoutPopup"), object: nil)
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
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
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
                return cell
            }
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.identifier, for: indexPath) as? SettingsTVC else {
                return UITableViewCell()
            }
            
            if indexPath.section == 0 {
                cell.setInformations(settingIconName: serviceSettingsName[0], settingIconImageName: serviceSettingsIconImageName[0])
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
            return 178
        } else {
            return 56.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
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
}

protocol UITableViewButtonSelectedDelegate: class {
    func logoutButtonPressed()
}

extension UITableViewButtonSelectedDelegate {
    func logoutButtonPressed() {}
}
