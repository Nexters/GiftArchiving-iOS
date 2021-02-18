//
//  NoticeVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/08.
//

import UIKit

struct Notice {
    
}
class NoticeVC: UIViewController {

    @IBOutlet weak var noticeTableView: UITableView!
    @IBOutlet weak var topContainer: UIView!
    
    @IBOutlet weak var emptyView: UIView!
    var noticeArray: [NoticeList] = [] {
        didSet {
            noticeTableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        NoticeService.shared.getNotice { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                guard let dt = data as? [NoticeList] else { return }
                self.noticeArray = dt
                
                if self.noticeArray.isEmpty {
                    self.showEmptyView(false)
                }
                
            case .requestErr:
                let alertViewController = UIAlertController(title: "통신 실패", message: "💩", preferredStyle: .alert)
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        
    }
    
    private func showEmptyView(_ direction: Bool) {
        emptyView.isHidden = direction
        noticeTableView.isHidden = !direction
    }
    
    private func initTableView() {
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        noticeTableView.backgroundColor = UIColor(red: 20.0 / 255.0, green: 20.0 / 255.0, blue: 22.0 / 255.0, alpha: 1.0)
    }
    
    @IBAction func popView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension NoticeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTVC.identifier, for: indexPath) as? NoticeTVC else { return UITableViewCell() }
        
        let date = noticeArray[indexPath.row].createdAt
        let date1 = date.split(separator: " ")[0]
        
        cell.setInformation(title: noticeArray[indexPath.row].title, content: noticeArray[indexPath.row].content, date: date1.replacingOccurrences(of: "-", with: "."))
        return cell
    }
    
    
}
