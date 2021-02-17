//
//  SplashVC.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/06.
//

import UIKit
import Lottie
import AuthenticationServices

class SplashVC: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        view.backgroundColor = .black
        let front = Date()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            LoadGiftListService.shared.getReceivedGifts(page: 0, size: 10000000, isReceiveGift: true, completion: {
                gifts in
                Gifts.receivedModels = gifts
                LoadGiftListService.shared.getReceivedGifts(page: 0, size: 10000000, isReceiveGift: false, completion: {
                    gifts in
                    Gifts.sentModels = gifts
                    //self.checkLoginAndDisplay()
                    let interval = front.distance(to: Date())
                    if interval < 2 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2 - interval) {
                            self.checkLoginAndDisplay()
                        }
                    }else{
                        self.checkLoginAndDisplay()
                    }
                    
                    
                })
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
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
            if let kakaoId = SPREF.string(forKey: "kakaoId"){

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
