//
//  MainVC.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/01/27.
//

import UIKit

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imgArrow: UIImageView!
    
    @IBOutlet weak var gfitBoxLabel: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var imgSetting: UIImageView!
    @IBOutlet weak var btnReceive: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var btnWrite: UIButton!
    
    var models = [Model]()
    var colors = [UIColor.black, UIColor.blue, UIColor.white, UIColor.brown]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        models.append(Model(text: "유진",
                            imageName: "img_test"))
        
        models.append(Model(text: "유진2",
                            imageName: "img_test"))
        models.append(Model(text: "유진3",
                            imageName: "img_test"))
        models.append(Model(text: "유진4",
                            imageName: "img_test"))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func configure(with models: [Model]) {
        self.models = models
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellforItemAt")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        cell.configure(with: models[indexPath.row])
        collectionView.backgroundColor = colors[indexPath.row]
        return cell
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }*/

}
struct Model {
    let text: String
    let imageName: String
    
    init(text: String, imageName: String){
        self.text = text
        self.imageName = imageName
    }
}
