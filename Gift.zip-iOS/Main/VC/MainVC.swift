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
    var colors = [UIColor(named: "ceruleanBlue"), UIColor.greyishBrown, UIColor(named: "pinkishOrange"), UIColor(named: "wheat")]
    var logos = [UIImage(named: "logo_blue"), UIImage(named: "logo_gray"), UIImage(named: "logo_orange"), UIImage(named: "logo_yellow")]
    var colorIdx = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        testData()
        setLayout()
        
    }
    
    func setLayout(){
        collectionView.delegate = self
        collectionView.dataSource = self
        (btnWrite as UIView).makeRounded(cornerRadius: 8.0)
    }
    
    func testData(){
        models.append(Model(text: "유진",
                            imageName: "img_test"))
        models.append(Model(text: "유진2",
                            imageName: "img_test"))
        models.append(Model(text: "유진3",
                            imageName: "img_test"))
        models.append(Model(text: "유진4",
                            imageName: "img_test"))
    }
    
    func configure(with models: [Model]) {
        self.models = models
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        cell.configure(with: models[indexPath.row])
        changeUI()
        return cell
    }
    func changeUI(){
        if (colorIdx == 4){
            colorIdx = 0
        }
        if(colorIdx == 3){
            imgArrow.image = UIImage(named: "btn_arrow_black")
            gfitBoxLabel.textColor = UIColor.greyishBrown
        }else{
            imgArrow.image = UIImage(named: "btn_arrow_white")
            gfitBoxLabel.textColor = UIColor.white
        }
        collectionView.backgroundColor = colors[colorIdx]
        imgLogo.image = logos[colorIdx]
        colorIdx += 1
    }
    

}
struct Model {
    let text: String
    let imageName: String
    
    init(text: String, imageName: String){
        self.text = text
        self.imageName = imageName
    }
}
