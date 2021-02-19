//
//  ListVC.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/02.
//

import UIKit

class ListVC: UIViewController {
    var models = [LoadGiftData]()
    var receivedSentFlag = true //보낸인지 받은 인지

    
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnCollectionViewType: UIButton!
    @IBOutlet weak var labelSort: UILabel!
    @IBOutlet weak var btnSort: UIButton!
    
    @IBOutlet weak var viewEmpty: UIView!
    
    var stickyCellFlowLayout : StickyCellFlowLayout?
    var gridCellFlowLayout : UICollectionViewLayout?
    var gridCellNib : UINib?
    var collectionViewFlowLayoutType = true // true는 stickyType false는 gridType
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resetData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setLayout()
        stickyCellFlowLayout = collectionView.collectionViewLayout as! StickyCellFlowLayout
        gridCellNib = UINib(nibName: "GridCollectionViewCell", bundle: nil)
        gridCellFlowLayout = createGridLayout()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 410, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(returnSortVC(_:)), name: .init("returnSortVC"), object: nil)
    }
    //MARK: SortVC noti
    @objc func returnSortVC(_ notification: Notification){
        guard let res = notification.userInfo?["res"] as? String else { return }
        sort(sortType: res)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .init("returnSortVC"), object: nil)
    }
    private func sort(sortType: String){
        labelSort.text = sortType
        //sort
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        models = models.sorted { model1, model2 in
            guard let date1 = formatter.date(from: model1.receiveDate) else { return true }
            guard let date2 = formatter.date(from: model2.receiveDate) else { return false }
            if sortType == "최신순" {
                return date1 > date2
            }else{
                return date1 < date2
            }
            
        }
        self.collectionView.reloadData()
        //self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    //MARK: resetData
    public func resetData() {
        if receivedSentFlag {
            models = Gifts.receivedModels
            self.sort(sortType: labelSort.text!)
        }else{
            models = Gifts.sentModels
            self.sort(sortType: labelSort.text!)
        }
        if models.count == 0 {
            collectionView.isHidden = true
            viewEmpty.isHidden = false
        }else{
            viewEmpty.isHidden = true
            collectionView.isHidden = false
        }
        labelCount.text = "\(models.count)"
        self.collectionView.reloadData()
    }
    //MARK: setLayout
    private func setLayout(){
        resetData()
        if receivedSentFlag {
            labelTop.text = "받은선물"
        }else{
            labelTop.text = "보낸선물"
        }
        if let layout = collectionView.collectionViewLayout as? StickyCellFlowLayout {
            layout.stickyIndexPath = []
            for index in 0..<models.count {
                layout.stickyIndexPath.append(IndexPath(row: index, section: 0))
            }
        }
        setupLabelTap()
    }
    //MARK: label sort tapped
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        self.showPopUp()
    }
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.labelSort.isUserInteractionEnabled = true
        self.labelSort.addGestureRecognizer(labelTap)
        
    }
    //MARK: show pop up
    private func showPopUp(){
        guard let popup = self.storyboard?.instantiateViewController(identifier: "SortVC") as? SortVC else { return }
        
        popup.modalPresentationStyle = .overFullScreen
        var idx = 0
        var target = -1
        for data in popup.sortData{
            if data.sortType == self.labelSort.text{
                target = idx
            }
            idx += 1
        }
        popup.sortData[target].isSelected = true
        present(popup, animated: true, completion: nil)
    }
    
    
//MARK: 버튼 클릭 이벤트
    @IBAction func btnCollectionViewTypeClicked(_ sender: UIButton) {
        if collectionViewFlowLayoutType {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
            sender.setImage(UIImage(named: "iconSticky"), for: .normal)
            collectionView.collectionViewLayout = self.gridCellFlowLayout!
            collectionView.register(gridCellNib, forCellWithReuseIdentifier: "GridCollectionViewCell")
            collectionViewFlowLayoutType = false
            collectionView.reloadData()
            
        }else{
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 410, right: 0)
            sender.setImage(UIImage(named: "iconGrid"), for: .normal)
            collectionView.collectionViewLayout = self.stickyCellFlowLayout!
            collectionViewFlowLayoutType = true
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            collectionView.reloadData()
            
        }
        
    }
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSortClicked(_ sender: UIButton) {
        self.showPopUp()
    }
    @IBAction func btnSearchClicked(_ sender: UIButton) {
        let searchSB = UIStoryboard(name: "SearchSB", bundle: nil)
        let vc = searchSB.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK: collectionview datasource
extension ListVC: UICollectionViewDataSource , UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionViewFlowLayoutType {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListCollectionViewCell
            cell.configure(with: models[indexPath.row], color: UIColor(named: models[indexPath.row].bgColor)! )
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as! GridCollectionViewCell
            cell.configure(with: models[indexPath.row], color: UIColor(named: models[indexPath.row].bgColor)! )
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailSB = UIStoryboard(name: "Detail", bundle: nil)
        guard let vc = detailSB.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else { return }
        
        vc.giftId = models[indexPath.row].id
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:  true, completion: nil)
    }
}
//MARK: - collectionview 콤포지셔널 레이아웃
extension ListVC{
    // 콤포지셔널 레이아웃 설정
    fileprivate func createGridLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            // 만들게 되면 튜플 (키: 값, 키: 값) 의 묶음으로 들어옴
            (sectionIndex: Int, layoutEvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            //아이템에 대한 사이즈 - absolute 는 고정값, estimated 는 추측, fraction은 퍼센트
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(208))
            
            //위에서 만든 아이템 사이즈로 아이템 만들기
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            //아이템 간격 설정
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            //그룹 사이즈
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(335), heightDimension: .absolute(224))
            //그룹사이즈로 그룹 만들기
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            group.interItemSpacing = .fixed(16)
            
            // 만든 그룹으로 섹션 만들기
            let section = NSCollectionLayoutSection(group: group)
            
            //섹션에 대한 간격 설정
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            return section
        }
        
        return layout
    }
}

