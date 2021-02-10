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
    var resArr = Array<Gift>()
    var resReceivedArr = Array<Gift>()
    var resSentArr = Array<Gift>()
    var resFlag = true // true는 받은 선물
    var giftCategory = ["모바일교환권", "패션", "화장품", "식품", "생활잡화", "디지털", "스포츠", "육아용품", "펫", "리빙", "상품권", "기타"]
    var giftReason = ["생일", "기념일", "취업", "집들이", "결혼", "학업", "명절", "응원", "사과", "감사", "그냥", "기타"]
    var recentSearchArr : Array<String> = []
    
    var colors = [UIColor(named: "ceruleanBlue"), UIColor.greyishBrown, UIColor(named: "pinkishOrange"), UIColor(named: "wheat")]
    var txtFieldCanListen = true
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
    
    @IBOutlet weak var warningView: UIView!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    @IBOutlet weak var btnReceived: UIButton!
    @IBOutlet weak var btnSent: UIButton!
    
    @IBOutlet weak var viewLeftBar: UIView!
    @IBOutlet weak var viewRightBar: UIView!
    
    @IBOutlet weak var viewResultEmpty: UIView!
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
        collectionView.dataSource = self
        collectionView.delegate = self
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        makeTestData()
        setLayout()
        
        
    }
    //MARK: 테스트 데이터 생성
    private func makeTestData(){
        receivedModels.append(Gift(name: "이름1", isReceiveGift: true, content: "내생일에 받음", receiveDate: "2020. 11. 02 (수)", category: "화장품", reason: "생일"))
        receivedModels.append(Gift(name: "이름1", isReceiveGift: true, content: "집들이 선물 받음", receiveDate: "2020. 11. 02 (수)", category: "기타", reason: "집들이"))
        receivedModels.append(Gift(name: "이름2", isReceiveGift: false, content: "음식이었다.", receiveDate: "2020. 11. 03 (목)", category: "식품", reason: "기념일"))
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
        
        //최근 검색 데이터 컬랙션 뷰 설정
        let recentNib = UINib(nibName: "RecentCollectionViewCell", bundle: nil)
        collectionView.register(recentNib, forCellWithReuseIdentifier: "RecentCollectionViewCell")
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 6
        
        //결과 컬랙션 뷰 설정
        let resultNib = UINib(nibName: "SearchResultCollectionViewCell", bundle: nil)
        searchResultCollectionView.register(resultNib, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        searchResultCollectionView.collectionViewLayout = self.createGridLayout()
        
        self.setRecentView()
        
        
        viewTxtFieldBack.backgroundColor = UIColor.secondary400
        txtFieldSearch.attributedPlaceholder = NSAttributedString(string: "이름, 내용 검색", attributes: [NSAttributedString.Key.foregroundColor : UIColor.charcoalGreyTwo])
        
        
        //scroll view 터치했을 때 키보드 내리기
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))

        singleTapGestureRecognizer.numberOfTapsRequired = 1

        singleTapGestureRecognizer.isEnabled = true

        singleTapGestureRecognizer.cancelsTouchesInView = false

        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        setFrontView(idx: 0)
        
        setGiveAndTakeTable()
        
        viewRightBar.backgroundColor = UIColor.primary400
        
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
        //table view 높이 지정
        cnstTableViewHeight.constant = CGFloat(nameArr.count) * 52.5
        
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
        setFrontView(idx: 0)
    }
    @IBAction func btnSearchClicked(_ sender: UIButton) {
    }
    @IBAction func btnBackClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDeleteRecentClicked(_ sender: UIButton) {
        self.deleteRecentSearchData()
    }
    @IBAction func btnReceivedClicked(_ sender: UIButton) {
        self.resFlag = true
        self.searchResultCollectionView.reloadData()
        self.viewLeftBar.backgroundColor = UIColor.white
        self.viewRightBar.backgroundColor = UIColor.primary400
        self.btnReceived.setTitleColor(UIColor.white, for: .normal)
        self.btnSent.setTitleColor(UIColor.greyishBrown, for: .normal)
    }
    @IBAction func btnSentClicked(_ sender: Any) {
        self.resFlag = false
        self.searchResultCollectionView.reloadData()
        self.viewLeftBar.backgroundColor = UIColor.primary400
        self.viewRightBar.backgroundColor = UIColor.white
        self.btnReceived.setTitleColor(UIColor.greyishBrown, for: .normal)
        self.btnSent.setTitleColor(UIColor.white, for: .normal)
    }
    //MARK: 키보드 관련
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //임시
        if let searchData = textField.text {
            setResDataByKeyword(keyword: searchData)
            showResultView(gifts: resArr, keyword: searchData)
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
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let keyword = textField.text{
            if txtFieldCanListen {
                search(keyword: keyword)
            }
        }
    }
    private func search(keyword: String){
        autoArr.removeAll()
        if keyword.count > 0{
            setFrontView(idx: 1)
            for model in receivedModels + sentModels{
                if model.name.contains(keyword) {
                    
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
                        
                        checkAndAddToAutoArr(keyword: keyword, label: result, gift: model)
                    }
                }
            }
        }
        if autoArr.count == 0 {
            setFrontView(idx: 2)
        }
        autoTableView.reloadData()
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
            setResDataByTag(tag: tagText)
            showResultView(gifts: resArr, keyword: tagText)
        }
        if(textTagCollectionView == self.tagCollectionView2){
            //reason 태그
            setResDataByTag(tag: tagText)
            showResultView(gifts: resArr, keyword: tagText)
        }
    }
    private func setResDataByTag(tag: String){
        resArr.removeAll()
        for model in receivedModels + sentModels{
            if model.category == tag {
                resArr.append(model)
            }else if model.reason == tag{
                resArr.append(model)
            }
        }
    }
    //MARK: 결과 뷰 띄우기
    private func showResultView(gifts: [Gift], keyword: String){
        self.resArr = gifts
        self.resReceivedArr.removeAll()
        self.resSentArr.removeAll()
        if self.resArr.count > 0 {
            //받은 선물 보낸 선물 count
            for gift in resArr {
                if gift.isReceiveGift {
                    self.resReceivedArr.append(gift)
                }else{
                    self.resSentArr.append(gift)
                }
            }
            self.resFlag = true
            var s = "받은 선물 " + String(self.resReceivedArr.count) as NSString
            self.btnReceived.setTitle(s as String, for: .normal)
            self.btnReceived.setTitleColor(UIColor.white, for:  .normal)
            var att = NSMutableAttributedString(string: s as String)
            var r = s.range(of: "[0-9]", options: .regularExpression, range: NSMakeRange(0,s.length))
            if r.length > 0 {
                att.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16),  range: r)
                btnReceived.setAttributedTitle(att, for: .normal)
            }
            s = "보낸 선물 " + String(self.resSentArr.count) as NSString
            self.btnSent.setTitle(s as String, for: .normal)
            self.btnSent.setTitleColor(UIColor.greyishBrown, for: .normal)
            att = NSMutableAttributedString(string: s as String)
            r = s.range(of: "[0-9]", options: .regularExpression, range: NSMakeRange(0,s.length))
            if r.length > 0 {
                att.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16),  range: r)
                btnSent.setAttributedTitle(att, for: .normal)
            }
            
            setFrontView(idx: 3)
        }else{
            setFrontView(idx: 2)
        }
        self.view.endEditing(true)
        self.resFlag = true
        self.searchResultCollectionView.reloadData()
        self.viewLeftBar.backgroundColor = UIColor.white
        self.viewRightBar.backgroundColor = UIColor.primary400
        searchResultCollectionView.reloadData()
        
        //keyword를 최근 검색어에 저장 , textfield를 keyword로
        self.txtFieldCanListen = false
        self.txtFieldSearch.text = keyword
        self.txtFieldCanListen = true
        self.addRecentSearchData(val: keyword)
    }
    private func setResDataByKeyword(keyword : String){
        resArr.removeAll()
        for model in receivedModels + sentModels{
            if model.name.contains(keyword) {
                resArr.append(model)
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
                    resArr.append(model)
                }
                
            }
            
        }
    }
    //MARK: 맨 앞에 보여지는 view 변경
    //0 : default scrollview , 1 : 자동화면 뷰 , 2 : warning 뷰, 3 : 결과 리스트 뷰
    func setFrontView(idx: Int){
        if idx == 0{
            self.scrollView.isHidden = false
            self.autoView.isHidden = true
            self.warningView.isHidden = true
            self.resultView.isHidden = true
        }else if idx == 1{
            self.scrollView.isHidden = true
            self.autoView.isHidden = false
            self.warningView.isHidden = true
            self.resultView.isHidden = true
        }else if idx == 2{
            self.scrollView.isHidden = true
            self.autoView.isHidden = true
            self.warningView.isHidden = false
            self.resultView.isHidden = true
        }else if idx == 3{
            self.scrollView.isHidden = true
            self.autoView.isHidden = true
            self.warningView.isHidden = true
            self.resultView.isHidden = false
        }
    }
}
//MARK: collectionview delegate, datasource extension
extension SearchVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return recentSearchArr.count
        }
        if collectionView == self.searchResultCollectionView{
            if resFlag{
                if resReceivedArr.count == 0{
                    viewResultEmpty.isHidden = false
                }else{
                    viewResultEmpty.isHidden = true
                    return resReceivedArr.count
                }
            }else{
                if resSentArr.count == 0{
                    viewResultEmpty.isHidden = false
                }else{
                    viewResultEmpty.isHidden = true
                    return resSentArr.count
                }
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCollectionViewCell", for: indexPath) as! RecentCollectionViewCell
            cell.configure(txt: recentSearchArr[indexPath.row])
            
            return cell
        }
        if collectionView == self.searchResultCollectionView{
            if resFlag {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as! SearchResultCollectionViewCell
                cell.configure(with: resReceivedArr[indexPath.row], color: colors[indexPath.row % 4]!)
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as! SearchResultCollectionViewCell
                cell.configure(with: resSentArr[indexPath.row], color: colors[indexPath.row % 4]!)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView{
            let label = UILabel(frame: CGRect.zero)
            label.text = recentSearchArr[indexPath.item]
            label.sizeToFit()
            return CGSize(width: label.frame.width, height: label.frame.height)
        }
        return CGSize(width: 160, height: 208)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            let keyword = self.recentSearchArr[indexPath.row]
            setResDataByKeyword(keyword: keyword)
            self.showResultView(gifts: resArr, keyword: keyword)
        }
        if collectionView == self.searchResultCollectionView{
            //상세화면 이동
            if resFlag{
                
            }else{
                
            }
        }
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
        
        if tableView == self.autoTableView {
            showResultView(gifts: self.autoArr[indexPath.row].gifts, keyword: self.autoArr[indexPath.row].label)
        }
        if tableView == self.tableView {
            let keyword = nameArr[indexPath.row]
            setResDataByKeyword(keyword: keyword)
            self.showResultView(gifts: resArr, keyword: keyword )
        }
        
    }
    
}
//MARK: search result collection view 의 compositional layout
extension SearchVC{
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
