//
//  ViewController.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/01/30.
//

import UIKit

class VC: UIViewController{
    
    enum AnimationDirection: Int {
      case positive = 1
      case negative = -1
    }
    
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
    @IBOutlet weak var bottomView: UIView!
    
    var currentIndex: Int = 0
    
    let lineSpacing: CGFloat = 0
    
    let cellRatio: CGFloat = 0.7
    
    var isOneStepPaging = true

    private var isReceiveGift: Bool = true

    private var collectionViewFlag = true // true는 받은 flase는 보낸
    
    private var device = 0 //device 크기 flag
    
    private var currentColor: UIColor = .charcoalGrey {
        didSet {
            if currentColor == UIColor.wheat {
//                collectionView.backgroundColor = UIColor(named: color)
                collectionView.reloadData()
                
//                collectionView.backgroundColor = UIColor(named: color)
//                if(color == "wheat") {
//                    btnArrow.imageView?.image = UIImage(named: "btn_arrow_black")
//                    btnGfitBox.titleLabel?.textColor = UIColor.greyishBrown
//                } else {
//                    btnArrow.imageView?.image = UIImage(named: "btn_arrow_white")
//                    btnGfitBox.titleLabel?.textColor = UIColor.white
//                }
//
//                if let cell : CollectionViewCell = collectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as? CollectionViewCell{
//                    cell.setLabelColor(color: color)
//                }
//                imgLogo.image = UIImage(named: "logo_"+color+"_"+frameType)
            }
        }
    }
    
    
    @IBOutlet weak var constLabelMain1Top: NSLayoutConstraint!
    @IBOutlet weak var constLabelMainWidth: NSLayoutConstraint!
    @IBOutlet weak var constLabelMainHeight: NSLayoutConstraint!
    @IBOutlet weak var constLabelMain2Height: NSLayoutConstraint!
    @IBOutlet weak var constLabelMain2Width: NSLayoutConstraint!
    @IBOutlet weak var constBtnWriteTop: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.reloadData()
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUIByCurrentIdx()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .init("deleteGift"), object: nil)
        NotificationCenter.default.removeObserver(self, name: .init("addGift"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if view.bounds.height > 810 {
            device = 1
        }else{
            device = 0
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        setLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(deleteGift), name: .init("deleteGift"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addGift), name: .init("addGift"), object: nil)
    }
    
    func cubeTransition(image: UIImageView, name: String, direction: AnimationDirection) {
        let auxImageView = UIImageView(frame: image.frame)
        auxImageView.image = UIImage.init(named: name)
        
        let auxLabelOffset = CGFloat(direction.rawValue) * image.frame.size.height/2.0
        
        auxImageView.transform = CGAffineTransform(translationX: 0.0, y: auxLabelOffset)
            .scaledBy(x: 1.0, y: 0.1)
        image.superview?.addSubview(auxImageView)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            auxImageView.transform = .identity
            image.transform = CGAffineTransform(translationX: 0.0, y: -auxLabelOffset)
                .scaledBy(x: 1.0, y: 0.1)
        }, completion: { _ in
            image.image = auxImageView.image
            image.transform = .identity
            
            auxImageView.removeFromSuperview()
        })
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
        
        if Gifts.receivedModels.count > 0 {
            changeUI(frameType: Gifts.receivedModels[0].frameType, color: Gifts.receivedModels[0].bgColor)
        }
    }
    
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        guard let settingsVC = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(identifier: "SettingsVC") as? SettingsVC else { return }
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @IBAction func btnSentClicked(_ sender: UIButton) {
        self.btnSent.titleLabel?.textColor = UIColor.white
        self.btnReceived.titleLabel?.textColor = UIColor.whiteOpacity
        self.collectionViewFlag = false
        isReceiveGift = false
        currentIndex = 0
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.moveBarToSentAnimate()
            if Gifts.sentModels.count > 0 {
                self.changeUI(frameType: Gifts.sentModels[0].frameType, color: Gifts.sentModels[0].bgColor)
            }
            self.collectionView.setContentOffset(CGPoint(x: -self.collectionView.contentInset.left,y:0), animated: true)
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func btnReceivedClicked(_ sender: UIButton) {
        self.btnReceived.titleLabel?.textColor = UIColor.white
        self.btnSent.titleLabel?.textColor = UIColor.whiteOpacity
        self.collectionViewFlag = true
        isReceiveGift = true
        currentIndex = 0
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.moveBarToReceivedAnimate()
            if Gifts.receivedModels.count > 0 {
                self.changeUI(frameType: Gifts.receivedModels[0].frameType, color: Gifts.receivedModels[0].bgColor)
            }
            self.collectionView.setContentOffset(CGPoint(x: -self.collectionView.contentInset.left,y:0), animated: true)
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func btnWriteClicked(_ sender: UIButton) {
        let recordSB = UIStoryboard(name: "Record", bundle: nil)
        guard let vc = recordSB.instantiateViewController(withIdentifier: "RecordVC") as? RecordVC else { return }
        vc.isReceiveGift = isReceiveGift
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnGfitBoxClicked(_ sender: UIButton) {
        let listSB = UIStoryboard(name: "ListSB", bundle: nil)
        let vc = listSB.instantiateViewController(withIdentifier: "ListVC") as! ListVC
        vc.receivedSentFlag = self.collectionViewFlag
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveBarToReceivedAnimate(){
        UIView.animate(withDuration: 0.3) {
            self.viewBar.transform =  CGAffineTransform(translationX: 0, y: 0)
        }
    }
    func moveBarToSentAnimate(){
        UIView.animate(withDuration: 0.3) {
            self.viewBar.transform =  CGAffineTransform(translationX:  self.viewBar.frame.width + 26, y: 0)
        }
    }
    
    @IBAction func btnSearchClicked(_ sender: UIButton) {
        let searchSB = UIStoryboard(name: "SearchSB", bundle: nil)
        let vc = searchSB.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnArrowClicked(_ sender: UIButton) {
        let listSB = UIStoryboard(name: "ListSB", bundle: nil)
        let vc = listSB.instantiateViewController(withIdentifier: "ListVC") as! ListVC
        vc.receivedSentFlag = self.collectionViewFlag
        navigationController?.pushViewController(vc, animated: true)
        
    }
    private func setUIByCurrentIdx(){
        if collectionViewFlag {
            if Gifts.receivedModels.count > 0 {
                changeUI(frameType: Gifts.receivedModels[currentIndex].frameType, color: Gifts.receivedModels[currentIndex].bgColor)
            }
        }else{
            if Gifts.sentModels.count > 0 {
                changeUI(frameType: Gifts.sentModels[currentIndex].frameType, color: Gifts.sentModels[currentIndex].bgColor)
            }
        }
        
    }
    @objc func deleteGift(){
        currentIndex = 0
        self.collectionView.setContentOffset(CGPoint(x: -self.collectionView.contentInset.left,y:0), animated: true)
    }
    @objc func addGift(){
        print("addGift()")
        currentIndex = 0
        self.collectionView.setContentOffset(CGPoint(x: -self.collectionView.contentInset.left,y:0), animated: true)
    }
    
}

//MARK: 컬랙션뷰 datasource, delegate, changeUI
extension VC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(currentIndex)
        if collectionViewFlag {
            if Gifts.receivedModels.count == 0 {
                self.collectionView.isScrollEnabled = false
                return 1
            }else{
                self.collectionView.isScrollEnabled = true
                return Gifts.receivedModels.count
            }
        }else{
            if Gifts.sentModels.count == 0 {
                self.collectionView.isScrollEnabled = false
                return 1
            }else{
                self.collectionView.isScrollEnabled = true
                return Gifts.sentModels.count
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        cell.setConstraint(device: device)
        if collectionViewFlag {
            if Gifts.receivedModels.count == 0 {
                cell.configureEmpty(flag: true, device: device)
                changeUIEmpty()
            } else {
                cell.configure(with: Gifts.receivedModels[indexPath.row])
            }
        } else {
            if Gifts.sentModels.count == 0 {
                cell.configureEmpty(flag: false, device: device)
                changeUIEmpty()
            } else {
                cell.configure(with: Gifts.sentModels[indexPath.row])
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionViewFlag{
            if Gifts.receivedModels.count != 0 {
                let detailSB = UIStoryboard(name: "Detail", bundle: nil)
                guard let vc = detailSB.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else { return }
                
                vc.giftId = Gifts.receivedModels[indexPath.row].id
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated:  true, completion: nil)
            }
        }else{
            if Gifts.sentModels.count != 0 {
                let detailSB = UIStoryboard(name: "Detail", bundle: nil)
                guard let vc = detailSB.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else { return }
                
                vc.giftId = Gifts.sentModels[indexPath.row].id
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated:  true, completion: nil)
            }
        }
        
    }
    func changeUIEmpty(){
        self.imgLogo.image = UIImage(named: "logo_charcoalGrey_SQUARE")
        self.collectionView.backgroundColor = UIColor(named: "charcoalGrey")
        self.btnGfitBox.titleLabel?.textColor = UIColor.white
        self.btnArrow.imageView?.image = UIImage(named: "btn_arrow_white")
        currentIndex = 0
    }
    
    func changeUI(frameType: String, color: String) {
        UIView.animate(withDuration: 0.4) {
            self.collectionView.backgroundColor = UIColor(named: color)
            if(color == "wheat") {
                self.btnArrow.imageView?.image = UIImage(named: "btn_arrow_black")
                self.btnGfitBox.titleLabel?.textColor = UIColor.greyishBrown
            } else {
                self.btnArrow.imageView?.image = UIImage(named: "btn_arrow_white")
                self.btnGfitBox.titleLabel?.textColor = UIColor.white
            }
            self.imgLogo.image = UIImage(named: "logo_"+color+"_"+frameType)
        }
//        if imgLogo != nil {
//            print("Not Nil")
//            let newLogo = UIImageView.init(frame: imgLogo.frame)
//            let name: String = "logo_"+color+"_"+frameType
//            newLogo.image = UIImage(named: name)
//            UIView.transition(from: imgLogo, to: newLogo, duration: 0.4, options: .transitionFlipFromBottom) { (_) in
                
//            }
//        } else {
//            print("Nil")
//        }
           
        
    }
}

//MARK: 스크롤뷰 델리겟
extension VC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if collectionViewFlag {
            if currentIndex == Gifts.receivedModels.count{
                currentIndex -= 1
            }
            if Gifts.receivedModels.count > 0 {
                self.changeUI(frameType: Gifts.receivedModels[currentIndex].frameType, color: Gifts.receivedModels[currentIndex].bgColor)
            }
        } else {

            if currentIndex == Gifts.sentModels.count{
                currentIndex -= 1
            }
            if Gifts.sentModels.count > 0 {
                self.changeUI(frameType: Gifts.sentModels[currentIndex].frameType, color: Gifts.sentModels[currentIndex].bgColor)
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex: CGFloat = round(index)
        
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
            if currentIndex > Int(roundedIndex) {
                currentIndex -= 1
                roundedIndex = CGFloat(currentIndex)
            } else if currentIndex < Int(roundedIndex) {
                currentIndex += 1
                roundedIndex = CGFloat(currentIndex)
            }
        }

        if collectionViewFlag {
            if Int(currentIndex) == Gifts.receivedModels.count{
                currentIndex -= 1
            }
            self.changeUI(frameType: Gifts.receivedModels[Int(currentIndex)].frameType, color: Gifts.receivedModels[Int(currentIndex)].bgColor)
            
        }else{
            if Int(currentIndex) == Gifts.sentModels.count{
                currentIndex -= 1
            }
            self.changeUI(frameType: Gifts.sentModels[Int(currentIndex)].frameType, color: Gifts.sentModels[Int(currentIndex)].bgColor)
            
        }

        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

extension VC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}
