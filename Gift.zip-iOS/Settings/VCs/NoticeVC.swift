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
    var noticeArray: [Notice] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if noticeArray.isEmpty {
            showEmptyView(false)
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
        return UITableViewCell()
    }
    
    
}
