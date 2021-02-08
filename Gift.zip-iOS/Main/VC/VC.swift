//
//  ViewController.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/01/30.
//

import UIKit

class VC: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnReceived: UIButton!
    @IBOutlet weak var btnSent: UIButton!
    @IBOutlet weak var viewBar: UIView!
    @IBOutlet weak var labelMain1: UILabel!
    @IBOutlet weak var labelMain2: UILabel!
    @IBOutlet weak var btnWrite: UIButton!
    @IBOutlet weak var btnGfitBox: UIButton!
    @IBOutlet weak var btnArrow: UIButton!
    
    var currentIndex: CGFloat = 0
    
    let lineSpacing: CGFloat = 20
    
    let cellRatio: CGFloat = 0.65
    
    var isOneStepPaging = true
    
    var receivedModels = [Model]()
    var sentModels = [Model]()
    
    var colors = [UIColor(named: "ceruleanBlue"), UIColor.greyishBrown, UIColor(named: "pinkishOrange"), UIColor(named: "wheat")]
    var logos = [[UIImage(named: "logo_blue_rec"), UIImage(named: "logo_blue_circle"), UIImage(named: "logo_blue_oval")],
                 [UIImage(named: "logo_grey_rec"), UIImage(named: "logo_grey_circle"), UIImage(named: "logo_grey_oval")],
                 [UIImage(named: "logo_orange_rec"), UIImage(named: "logo_orange_circle"), UIImage(named: "logo_orange_oval")],
                 [UIImage(named: "logo_yellow_rec"), UIImage(named: "logo_yellow_circle"), UIImage(named: "logo_yellow_oval")]]
    
    var colorIdx = 0
    private var collectionViewFlag = true // true는 받은 flase는 보낸
    
    private var device = 0 //device 크기 flag
    
    
    @IBOutlet weak var constLabelMain1Top: NSLayoutConstraint!
    @IBOutlet weak var constLabelMainWidth: NSLayoutConstraint!
    @IBOutlet weak var constLabelMainHeight: NSLayoutConstraint!
    @IBOutlet weak var constLabelMain2Height: NSLayoutConstraint!
    @IBOutlet weak var constLabelMain2Width: NSLayoutConstraint!
    @IBOutlet weak var constBtnWriteTop: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if view.bounds.height > 840 {
            device = 1
        }else{
            device = 0
        }
        testData()
        setLayout()
    }
    func setLayout(){
        var cellHeight = CGFloat(330)
        if device == 0 {
            collectionViewHeight.setValue(330, forKey: "Constant")
            cellHeight = CGFloat(330)
        }else{
            collectionViewHeight.setValue(410, forKey: "Constant")
            cellHeight = CGFloat(410)
            constLabelMain1Top.setValue(60, forKey: "Constant")
            constLabelMainHeight.setValue(38, forKey: "Constant")
            constLabelMainWidth.setValue(150, forKey: "Constant")
            constLabelMain2Height.setValue(38, forKey: "Constant")
            constLabelMain2Width.setValue(110, forKey: "Constant")
            labelMain1.font = labelMain1.font.withSize(26)
            labelMain2.font = labelMain2.font.withSize(26)
            constBtnWriteTop.setValue(20, forKey: "Constant")
            
        }
        
        // width, height 설정
        let cellWidth = floor(view.frame.width * cellRatio)
        //let cellHeight = floor(view.frame.height * cellRatio / 2)
        
        // 상하, 좌우 inset value 설정
        let insetX = ((view.bounds.width - cellWidth) / 2.0) 
        
        //let insetY = ((view.bounds.height - cellHeight) / 2.0 )
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = .horizontal
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 스크롤 시 빠르게 감속 되도록 설정
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        (btnWrite as UIView).makeRounded(cornerRadius: 8.0)
        
        if receivedModels.count > 0 {
            changeUI(shape: receivedModels[0].shape)
        }
    }
    
    func testData(){
        receivedModels.append(Model(name: "From.유진",
                            imageName: "img_test",
                            isGiven: false,
                            date: "2020.01.31",
                            shape: 0))
        receivedModels.append(Model(name: "From.유진2",
                            imageName: "img_test",
                            isGiven: false,
                            date: "2020.01.31",
                            shape: 1))
        receivedModels.append(Model(name: "From.유진3",
                            imageName: "img_test",
                            isGiven: false,
                            date: "2020.01.31",
                            shape: 2))
        receivedModels.append(Model(name: "From.유진4",
                            imageName: "img_test",
                            isGiven: false,
                            date: "2020.01.31",
                            shape: 0))
        
        sentModels.append(Model(name: "To.유진1",
                                imageName: "img_test",
                                isGiven: false,
                                date: "2020.01.31",
                                shape: 0))
        sentModels.append(Model(name: "To.유진2",
                                imageName: "img_test",
                                isGiven: false,
                                date: "2020.01.31",
                                shape: 0))
        sentModels.append(Model(name: "To.유진3",
                                imageName: "img_test",
                                isGiven: false,
                                date: "2020.01.31",
                                shape: 0))
        sentModels.append(Model(name: "To.유진4",
                                imageName: "img_test",
                                isGiven: false,
                                date: "2020.01.31",
                                shape: 0))
        
    }
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        guard let settingsVC = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(identifier: "SettingsVC") as? SettingsVC else { return }
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @IBAction func btnSentClicked(_ sender: UIButton) {
        self.btnSent.titleLabel?.textColor = UIColor.white
        self.btnReceived.titleLabel?.textColor = UIColor.whiteOpacity
        self.collectionViewFlag = false
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.moveBarToSentAnimate()
            self.collectionView.reloadData()
        }
    }
    @IBAction func btnReceivedClicked(_ sender: UIButton) {
        self.btnReceived.titleLabel?.textColor = UIColor.white
        self.btnSent.titleLabel?.textColor = UIColor.whiteOpacity
        self.collectionViewFlag = true
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.moveBarToReceivedAnimate()
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func btnWriteClicked(_ sender: UIButton) {
        let recordSB = UIStoryboard(name: "Record", bundle: nil)
        let vc = recordSB.instantiateViewController(withIdentifier: "RecordVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnGfitBoxClicked(_ sender: UIButton) {
        let listSB = UIStoryboard(name: "ListSB", bundle: nil)
        let vc = listSB.instantiateViewController(withIdentifier: "ListVC") as! ListVC
        if self.collectionViewFlag{
            vc.models = self.receivedModels
        }else{
            vc.models = self.sentModels
        }
        vc.receivedSentFlag = self.collectionViewFlag
        navigationController?.pushViewController(vc, animated: true)
    }
    func moveBarToReceivedAnimate(){
        UIView.animate(withDuration: 0.5) {
            self.viewBar.transform =  CGAffineTransform(translationX: 0, y: 0)
        }
    }
    func moveBarToSentAnimate(){
        UIView.animate(withDuration: 0.5) {
            self.viewBar.transform =  CGAffineTransform(translationX:  self.viewBar.frame.width + 26, y: 0)
        }
    }
    
    
}

extension VC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionViewFlag {
            return receivedModels.count
        }else{
            return sentModels.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        cell.setConstraint(device: device)
        if collectionViewFlag{
            cell.configure(with: receivedModels[indexPath.row])
        }else{
            cell.configure(with: sentModels[indexPath.row])
        }
        
        return cell
    }
    func changeUI(shape: Int){
        if (colorIdx == 4){
            colorIdx = 0
        }
        if(colorIdx == 3){
            btnArrow.imageView?.image = UIImage(named: "btn_arrow_black")
            btnGfitBox.titleLabel?.textColor = UIColor.greyishBrown
        }else{
            btnArrow.imageView?.image = UIImage(named: "btn_arrow_white")
            btnGfitBox.titleLabel?.textColor = UIColor.white
        }
        collectionView.backgroundColor = colors[colorIdx]
        if let cell : CollectionViewCell = collectionView.cellForItem(at: IndexPath(row: Int(currentIndex), section: 0)) as? CollectionViewCell{
            cell.setLabelColor(colorIdx: colorIdx)
        }
        imgLogo.image = logos[colorIdx][shape]
        colorIdx += 1
    }
    
}

extension VC : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if isOneStepPaging {
            if currentIndex > roundedIndex {
                currentIndex -= 1
                roundedIndex = currentIndex
            } else if currentIndex < roundedIndex {
                currentIndex += 1
                roundedIndex = currentIndex
            }
        }
        if collectionViewFlag {
            self.changeUI(shape: receivedModels[Int(currentIndex)].shape)
        }else{
            self.changeUI(shape: sentModels[Int(currentIndex)].shape)
        }
        
        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
//임시 모델
struct Model {
    let name: String
    let imageName: String
    let isGiven: Bool
    let date: String
    let shape: Int
    
    init(name: String, imageName: String, isGiven: Bool, date: String, shape: Int){
        self.name = name
        self.imageName = imageName
        self.isGiven = isGiven
        self.date = date
        self.shape = shape
    }
}
