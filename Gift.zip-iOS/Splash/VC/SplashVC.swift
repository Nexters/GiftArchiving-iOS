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
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        if checkLogin() {
            self.getDataAndDisplay()
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
                self.moveToOnboarding()
            }
        }
        view.backgroundColor = .black
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    private func checkLogin() -> Bool{
        let SPREF = UserDefaults.standard
        if let appleId = SPREF.string(forKey: "appleId"){
            if !appleId.isEmpty {

                return true
            }
        }else{
            if let kakaoId = SPREF.string(forKey: "kakaoId"){
                if !kakaoId.isEmpty{
                    return true
                }
            }
        }
        return false
    }
    
    private func getDataAndDisplay(){
        let front = Date()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            LoadGiftListService.shared.getReceivedGifts(page: 0, size: 10000000, isReceiveGift: true, completion: {
                gifts in
                if let receivedArr = gifts {
                    Gifts.receivedModels = receivedArr
                    LoadGiftListService.shared.getReceivedGifts(page: 0, size: 10000000, isReceiveGift: false, completion: {
                            gifts in
                            if let sentArr = gifts {
                                Gifts.sentModels = sentArr
                                let interval = front.distance(to: Date())
                                if interval < 2 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2 - interval) {
                                        self.moveToMain()
                                    }
                                }else{
                                    self.moveToMain()
                                }
                        }
                    })
                }else{
                    if gifts == nil{
                        //network fail
                        let alertViewController = UIAlertController(title: "통신 실패", message: "네트워크 오류", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                        alertViewController.addAction(action)
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                }
            })
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
