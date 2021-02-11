//
//  SplashVC.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/06.
//

import UIKit
import Lottie
import AuthenticationServices

class SplashVC: UIViewController {
    
    //애니메이션 뷰 추가
    let animationView : AnimationView = {
        let animView = AnimationView(name: "lottiegift")
        //사각형만들기
        animView.frame = CGRect(x:0, y:0, width: 400, height: 400)
        //scale맞도록 이미지를 확대하겠다.
        animView.contentMode = .scaleAspectFit
        return animView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        view.addSubview(animationView)
        animationView.center = view.center
        
        //애니메이션 실행
        //종료시 콜백
        animationView.play{ (finish) in
            print("애니메이션 종료되었습니다.")
            
            //기존의 애니메이션 삭제
            self.animationView.removeFromSuperview()
            
            let SPREF = UserDefaults.standard
            print(UserDefaults.standard.string(forKey: "kakaoId"))
            print(UserDefaults.standard.string(forKey: "appleId"))
            print(Date())
            if let appleId = SPREF.string(forKey: "appleId"){
                if !appleId.isEmpty {
                    self.moveToMain()
                }else{
                    self.moveToOnboarding()
                }
            }else{
                if SPREF.string(forKey: "kakaoId") != nil{
                    self.moveToMain()
                }else{
                    self.moveToOnboarding()
                }
            }
            
        }
    }
    func moveToMain(){
        //메인 이동
        let mainSB = UIStoryboard(name: "MainSB", bundle: nil)
        let vc = mainSB.instantiateViewController(withIdentifier: "MainVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func moveToOnboarding(){
        //온보딩 화면 이동
        let onboardSB = UIStoryboard(name: "OnboardingSB", bundle: nil)
        let vc = onboardSB.instantiateViewController(withIdentifier: "OnboardingVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
