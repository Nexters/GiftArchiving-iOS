//
//  SearchVC.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/06.
//

import UIKit
import TTGTagCollectionView

class SearchVC: UIViewController, TTGTextTagCollectionViewDelegate, UITextFieldDelegate, UIScrollViewDelegate{
    var receivedModels = [Gift]()
    var sentModels = [Gift]()
    var nameArr = Array<String>() //그동안 주고 받은 사람들 테이블 뷰의 data
    var autoArr = Array<AutoSearchCellData>() // 자동완성 테이블 뷰의 data
    var giftCategory = ["모바일교환권", "패션", "화장품", "식품", "생활잡화", "디지털", "스포츠", "육아용품", "펫", "리빙", "상품권", "기타"]
    var giftReason = ["생일", "기념일", "취업", "집들이", "결혼", "학업", "명절", "응원", "사과", "감사", "그냥", "기타"]
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
    
    @IBOutlet weak var autoView: UIView!
    
    @IBOutlet weak var autoTableView: UITableView!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtFieldSearch.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        autoTableView.dataSource = self
        autoTableView.delegate = self
        scrollView.delegate = self
        makeTestData()
        setLayout()
        //임시
        
    }
    //MARK: 테스트 데이터 생성
    private func makeTestData(){
        receivedModels.append(Gift(name: "이름1", isReceiveGift: true, content: "내생일에 받음", receiveDate: "2020. 11. 02 (수)", category: "화장품", reason: "생일"))
        receivedModels.append(Gift(name: "이름2", isReceiveGift: true, content: "음식이었다.", receiveDate: "2020. 11. 03 (목)", category: "식품", reason: "기념일"))
        receivedModels.append(Gift(name: "이름3", isReceiveGift: true, content: "고양이 장난감", receiveDate: "2020. 11. 03 (목)", category: "펫", reason: "기타"))
        receivedModels.append(Gift(name: "이름4", isReceiveGift: true, content: "취업선물로 패딩받음", receiveDate: "2020. 11. 04 (금)", category: "패션", reason: "취업"))
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
            tagCollectionView.addTags(giftReason, with: config)
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
        
        //autoView 설정
        autoView.isHidden = true
        
        setGiveAndTakeTable()
        
    }
    //MARK: 그동안 주고 받은 사람들은 관련
    private func setGiveAndTakeTable(){
        //그동안 주고 받은 사람들 테이블 세팅
        //받은 선물리스트와 보낸 선물리스트에서 이름을 읽어서 nameArr에 저장. nameArr의 값들이 table의 cell의 label 값
        var set = Set<String>()
        for model in receivedModels {
            
            set.insert(model.name)
        }
        for model in sentModels {
            set.insert(model.name)
        }
        for name in set {
            self.nameArr.append(name)
        }
        self.nameArr.sort()
        tableView.reloadData()
         
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
        txtFieldSearch.text = ""
        self.view.endEditing(true)
        scrollView.isHidden = false
        autoView.isHidden = true
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
    //MARK: 자동 완성 검색기능 관련
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let keyword = textField.text{
            autoArr.removeAll()
            if keyword.count > 0 {
                scrollView.isHidden = true
                autoView.isHidden = false
                //keyword로 검색 해서. 자동완성 띄우기
                
                for model in receivedModels + sentModels{
                    if model.name.contains(keyword) {
                        print("keyword : " + keyword + " name : " + model.name)
                        checkAndAddToAutoArr(keyword: keyword, label: model.name, gift: model)
                    }else{
                        let regex = try! NSRegularExpression(pattern: keyword, options: [])
                        let range = NSRange(location: 0, length: model.content.utf16.count)
                        var idx = -1
                        for match in regex.matches(in: model.content, options: [], range: range) {
                            idx = match.range.lowerBound
                            break//첫번째 일치하는 위치
                        }
                        if idx == -1{
                            //매칭 실패
                        }else{
                            let startIdx: String.Index = model.content.index(model.content.startIndex, offsetBy: idx)

                            let result = String(model.content[startIdx...])
                            print("keyword : " + keyword + " content : " + result)
                            checkAndAddToAutoArr(keyword: keyword, label: result, gift: model)
                        }
                        
                    }
                    
                }
            }
            autoTableView.reloadData()
        }
    }
    private func checkAndAddToAutoArr(keyword: String, label: String, gift: Gift){
        //autoArr에 같은 label 있는지 체크하고 있으면 거기에 gift만 추가. 없으면 autoArr에 새로추가
        var flag = true
        if(autoArr.count > 0){
            for x in 0...(autoArr.count-1) {
                if autoArr[x].label == label {
                    autoArr[x].gifts.append(gift)
                    flag = false
                    break
                }
            }
        }
        if flag {
            autoArr.append(AutoSearchCellData(keyword: keyword, label: label, gifts: [gift]))
        }
    }
    //MARK: 태그 검색기능
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        textTagCollectionView.setTagAt(index, selected: false)
        if(textTagCollectionView == self.tagCollectionView){
            //카테고리 태그
            
        }
        if(textTagCollectionView == self.tagCollectionView2){
            //reason 태그
        }
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
        return CGSize(width: label.frame.width, height: label.frame.height)
    }
}
//MARK: tableView datasource, delegate extension
extension SearchVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return nameArr.count
        }
        if tableView == self.autoTableView{
            return autoArr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
            cell.configure(name: nameArr[indexPath.row])
            return cell
        }
        if tableView == self.autoTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AutoTableViewCell") as!  AutoTableViewCell
            cell.configure(label: autoArr[indexPath.row].label, keyword: autoArr[indexPath.row].keyword)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //autoArr의 gifts 리스트를 띄우기
        
    }
    
}
//MARK: 임시 모델
struct Gift {
    let name: String
    let isReceiveGift: Bool
    let content: String
    let receiveDate: String
    let category: String
    let reason: String
    
    init(name: String, isReceiveGift: Bool, content: String, receiveDate: String, category: String, reason: String){
        self.name = name
        self.isReceiveGift = isReceiveGift
        self.content = content
        self.receiveDate = receiveDate
        self.category = category
        self.reason = reason
    }
}
struct AutoSearchCellData{
    let keyword: String
    let label: String
    var gifts: Array<Gift>
    init(keyword: String, label: String, gifts: Array<Gift>) {
        self.keyword = keyword
        self.label = label
        self.gifts = gifts
    }
}
