//
//  OnboardingVC.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/04.
//

import UIKit
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

class OnboardingVC: UIViewController, ASAuthorizationControllerPresentationContextProviding ,ASAuthorizationControllerDelegate {
    
    let imgs = [UIImage(named: "imgOnboarding1"), UIImage(named: "imgOnboarding2"), UIImage(named: "imgOnboarding3"), UIImage(named: "imgOnboarding4")]
    let txtTop1 = ["주고받은", "주고받은", "친구에게 기록을", "선물 기록을"]
    let txtTop2 = ["선물을 기록해보세요", "선물을 기록해보세요", "공유해보세요", "차곡차곡 모아보세요"]
    let txtTop3 = ["선물 종류부터 감정, 원하는 스티커까지", "선물 종류부터 감정, 원하는 스티커까지", "",
    ""]
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnKakaoLogin: UIButton!
    
    @IBOutlet weak var btnAppleLogin: UIButton!
    
    @IBOutlet weak var cnstCollectionViewTop: NSLayoutConstraint!
    @IBOutlet weak var cnstAppleBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var cnstPageControlTop: NSLayoutConstraint!
    var device = 0
    var itemHeight = 455
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setlayout()
        
    }
    private func setlayout(){
        if view.bounds.height > 810 {
            device = 1
        }else{
            device = 0
        }
        if device == 0 {
            cnstCollectionViewTop.constant = 30
            cnstAppleBtnBottom.constant = 25
            itemHeight = 410
            cnstPageControlTop.constant = -20
        }
        collectionView.collectionViewLayout = self.createCompositionalLayout()
        let nib = UINib(nibName: "OnboardingCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        collectionView.dataSource = self
        
        
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = imgs.count
        pageControl.pageIndicatorTintColor = .darkGray
        
        btnKakaoLogin.layer.cornerRadius = 6
        btnKakaoLogin.backgroundColor = UIColor.dandelion
        btnAppleLogin.layer.cornerRadius = 6
    }
    // Apple Login Button Pressed
    @IBAction func btnAppleLoginClicked(_ sender: UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user//userIdentifier를 앱 내부에 저장해서 appdelegate 에서 불러와서 이미 로그인한 유저인지 판단해야 할 듯??
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            /*
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")*/
            //loginAPI 호출
            self.loginAPI(appleToken: userIdentifier, kakaoToken: "", loginType: "APPLE", name: "")
     
        default:
            break
        }
    }
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //handle error
        print("apple ID 연동 실패 :  authorizationController() called ")
    }
    
    @IBAction func kakaoSignInBtnClicked(_ sender: UIButton) {
        // 카카오톡 설치 여부 확인
        if(AuthApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                
                if let error = error {
                    // 예외 처리 (로그인 취소 등)
                    print(error)
                }
                else {
                    //사용자 관리 api 호출
                    UserApi.shared.me() {(user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            _ = user
                            if let userId = user?.id{
                                self.loginAPI(appleToken: "", kakaoToken: String(userId), loginType: "KAKAO", name: "")
                            }
                        }
                    }
                    
                }
            }
       }
    }
    func loginAPI(appleToken : String, kakaoToken: String, loginType : String, name: String){
        // 전송할 값
        var param : Dictionary<String, String> = [:]
        if loginType == "KAKAO"{
            param = ["token" : kakaoToken, "loginType" : loginType, "name": name]
        }else{
            param = ["token" : appleToken, "loginType" : loginType, "name": name]
        }
        // JSON 객체로 전송할 딕셔너리
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        // URL 객체 정의
        let url = URL(string: APIConstants.baseURL + APIConstants.signInURL)
        
        // URLRequest 객체를 정의
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        // HTTP 메시지 헤더
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        // URLSession 객체를 통해 전송, 응답값 처리
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 서버가 응답이 없거나 통신이 실패
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    
                    // JSON 결과값을 추출
                    let result = jsonObject["message"] as? String
                    
                    // 결과가 성공일 경우
                    if result == "SUCCESS" {
                        print("login API Success")
                        let SPREF = UserDefaults.standard
                        if loginType == "KAKAO"{
                            SPREF.setValue(kakaoToken, forKey: "kakaoId")
                        }else if loginType == "APPLE"{
                            SPREF.setValue(appleToken, forKey: "appleId")
                        }
                        
                        //메인 이동
                        
                        let recordSB = UIStoryboard(name: "MainSB", bundle: nil)
                        let vc = recordSB.instantiateViewController(withIdentifier: "MainVC")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } catch let e as NSError {
                    print("An error has occured while parsing JSONObject: \(e.localizedDescription)")
                }
            }
        }
        // POST 전송
        task.resume()
    }
    


}

extension OnboardingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.configure(img: imgs[indexPath.row]!, txtTop1: txtTop1[indexPath.row], txtTop2: txtTop2[indexPath.row], txtTop3: txtTop3[indexPath.row], device: device)
        return cell
            
        
    }
}
//MARK: - collectionview 콤포지셔널 레이아웃
extension OnboardingVC{
    // 콤포지셔널 레이아웃 설정
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            // 만들게 되면 튜플 (키: 값, 키: 값) 의 묶음으로 들어옴
            (sectionIndex: Int, layoutEvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            //아이템에 대한 사이즈 - absolute 는 고정값, estimated 는 추측, fraction은 퍼센트
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(CGFloat(self.itemHeight)))
            
            //위에서 만든 아이템 사이즈로 아이템 만들기
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            //아이템 간격 설정
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            //그룹 사이즈
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(CGFloat(self.itemHeight)))
            //그룹사이즈로 그룹 만들기
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            //group.interItemSpacing = .fixed(16)
            
            // 만든 그룹으로 섹션 만들기
            let section = NSCollectionLayoutSection(group: group)
            
            //섹션에 대한 간격 설정
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .groupPaging
            section.visibleItemsInvalidationHandler = { visibleItems, scrollOffset, layoutEnvironment in
                //이렇게 해주면 paging이 완전히 되었을 때 page control 의 currentpage값을 알맞게 갱신할 수 있음
                self.pageControl.currentPage = Int(round(scrollOffset.x / self.collectionView.frame.width))
            }
            return section
        }
        
        return layout
    }
}
