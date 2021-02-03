//
//  ListVC.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/02.
//

import UIKit

class ListVC: UIViewController {
    var models = [Model]()
    var receivedSentFlag = true //보낸인지 받은 인지
    var colors = [UIColor(named: "ceruleanBlue"), UIColor.greyishBrown, UIColor(named: "pinkishOrange"), UIColor(named: "wheat")]
    
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnCollectionViewType: UIButton!
    @IBOutlet weak var labelSort: UILabel!
    @IBOutlet weak var btnSort: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let layout = collectionView.collectionViewLayout as? StickyCellFlowLayout {
            layout.stickyIndexPath = []
            for index in 0..<models.count {
                layout.stickyIndexPath.append(IndexPath(row: index, section: 0))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnCollectionViewTypeClicked(_ sender: UIButton) {
    }
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListCollectionViewCell
        
        
        cell.configure(with: models[indexPath.row], color: colors[indexPath.row % 4]! )
        
        return cell
    }
}

