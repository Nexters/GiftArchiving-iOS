//
//  SortVC.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/19.
//

import UIKit

class SortVC: UIViewController {

    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet var viewBack: UIView!
    @IBOutlet weak var viewOut: UIView!
    @IBOutlet weak var tableView: UITableView!
    var sortData = [SortModel(sortType: "최신순"), SortModel(sortType: "과거순")]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLayout()
    }
    private func setLayout(){
        viewBottom.roundCorners(cornerRadius: 8.0, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        viewOut.addGestureRecognizer(tapGesture)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

    }
    

    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
        
    }


}
struct SortModel {
    var sortType : String
    var isSelected :Bool
    init(sortType: String) {
        self.sortType = sortType
        self.isSelected = false
    }
}
extension SortVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortTableViewCell") as! SortTableViewCell
        cell.configure(model: sortData[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let res = ["res" : sortData[indexPath.row].sortType]
        NotificationCenter.default.post(name: .init("returnSortVC"), object: nil, userInfo: res)
        self.dismiss(animated: true, completion: nil)
    }
    
}
