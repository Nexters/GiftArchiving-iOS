//
//  SearchVC.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/06.
//

import UIKit
import TTGTagCollectionView

class SearchVC: UIViewController, TTGTextTagCollectionViewDelegate, UITextFieldDelegate, UIScrollViewDelegate{
    

    var giftCategory = ["모바일교환권", "패션", "화장품", "식품", "생활잡화", "디지털", "스포츠", "육아용품", "펫", "리빙", "상품권", "기타"]
    var giftSituation = ["생일", "기념일", "취업", "집들이", "결혼", "학업", "명절", "응원", "사과", "감사", "그냥", "기타"]
    var recentSearchArr : Array<String> = []
    @IBOutlet weak var tagCollectionView: TTGTextTagCollectionView!
    
    @IBOutlet weak var tagCollectionView2: TTGTextTagCollectionView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    
    @IBOutlet weak var cnstViewRecentHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRecent: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewTxtFieldBack: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cnstTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtFieldSearch.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        setLayout()
        
    }
    // MARK: 레이아웃 관련 초기 세팅
    private func setTagCollectionView(tagCollectionView: TTGTextTagCollectionView, flag: Bool){
        tagCollectionView.alignment = .left
        tagCollectionView.delegate = self
        let config = TTGTextTagConfig()
        config.backgroundColor = UIColor.charcoalGreyThree
        config.textColor = .white
        config.textFont = UIFont.systemFont(ofSize: 14)
        config.selectedBackgroundColor = UIColor.colorTagClicked
        config.selectedBorderWidth = 0
        config.selectedCornerRadius = 19.4
        config.cornerRadius = 19.4
        config.borderWidth = 0
        config.borderColor = UIColor.charcoalGreyThree
        config.extraSpace = CGSize(width: 24.0, height: 12.0)
        tagCollectionView.verticalSpacing = 6
        tagCollectionView.horizontalSpacing = 6
        if flag{
            tagCollectionView.addTags(giftCategory, with: config)
        }else{
            tagCollectionView.addTags(giftSituation, with: config)
        }
        
    }
    private func setLayout(){
        setTagCollectionView(tagCollectionView: self.tagCollectionView, flag: true)
        setTagCollectionView(tagCollectionView: self.tagCollectionView2, flag: false)
        
        let nib = UINib(nibName: "RecentCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "RecentCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 6
        self.setRecentView()
        
        viewTxtFieldBack.backgroundColor = UIColor.secondary400
        txtFieldSearch.attributedPlaceholder = NSAttributedString(string: "이름, 내용 검색", attributes: [NSAttributedString.Key.foregroundColor : UIColor.charcoalGreyTwo])
        
        //table view 높이 지정
        cnstTableViewHeight.constant = 10 * 52.5
        
        //scroll view 터치했을 때 키보드 내리기
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))

        singleTapGestureRecognizer.numberOfTapsRequired = 1

        singleTapGestureRecognizer.isEnabled = true

        singleTapGestureRecognizer.cancelsTouchesInView = false

        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
    }
    //MARK: 최근 검색 데이터 관련
    public func getRecentSearch() -> Array<String> {
        let defaults = UserDefaults.standard
        if let array = defaults.array(forKey: "recentSearchData")  as? Array<String>{
            return array
        }
        return []
    }
    public func deleteRecentSearchData(){
        let defaults = UserDefaults.standard
        defaults.set([], forKey: "recentSearchData")
        self.setRecentView()
    }
    public func addRecentSearchData(val: String){
        let defaults = UserDefaults.standard
        var arr = self.getRecentSearch()
        arr.append(val)
        defaults.set(arr, forKey: "recentSearchData")
        self.setRecentView()
    }
    public func setRecentView(){
        self.recentSearchArr = getRecentSearch()
        //최근검색어 데이터가 0이면 recentView를 숨긴다. 0이 아니면 띄운다.
        if self.recentSearchArr.count == 0{
            //collectionview 숨기기
            self.cnstViewRecentHeight.setValue(0, forKey: "Constant")
            self.viewRecent.isHidden = true
        }else{
            self.cnstViewRecentHeight.setValue(98, forKey: "Constant")
            self.viewRecent.isHidden = false
        }
        self.collectionView.reloadData()
    }
    
    // MARK: btn click event
    @IBAction func btnDeleteClicked(_ sender: UIButton) {
    }
    @IBAction func btnSearchClicked(_ sender: UIButton) {
    }
    @IBAction func btnBackClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDeleteRecentClicked(_ sender: UIButton) {
        self.deleteRecentSearchData()
    }
    
    //MARK: 키보드 관련
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        //임시
        if let searchData = textField.text {
            self.addRecentSearchData(val: searchData)
        }
        return true
    }
    //스크롤뷰 탭 했을 때 실행되는 메서드 
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    //스크롤 했을 때 키보드 내리기
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){

        self.view.endEditing(true)

    }
    
}
//MARK: collectionview delegate, datasource extension
extension SearchVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSearchArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCollectionViewCell", for: indexPath) as! RecentCollectionViewCell
        cell.configure(txt: recentSearchArr[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = recentSearchArr[indexPath.item]
        label.sizeToFit()
        print(label.frame.width)
        return CGSize(width: label.frame.width, height: label.frame.height)
    }
}
//MARK: tableView datasource, delegate extension
extension SearchVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.configure(name: "유진진")
        return cell
    }
    
    
}
