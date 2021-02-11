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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.checkLoginAndDisplay()
        }
    }

    private func checkLoginAndDisplay(){
        let SPREF = UserDefaults.standard
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
    private func moveToMain(){
        //메인 이동
        let mainSB = UIStoryboard(name: "MainSB", bundle: nil)
        let vc = mainSB.instantiateViewController(withIdentifier: "MainVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func moveToOnboarding(){
        //온보딩 화면 이동
        let onboardSB = UIStoryboard(name: "OnboardingSB", bundle: nil)
        let vc = onboardSB.instantiateViewController(withIdentifier: "OnboardingVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
