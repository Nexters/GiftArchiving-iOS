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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        view.backgroundColor = .black
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if checkLogin() {
            self.getDataAndDisplay()
        }else{
            self.moveToOnboarding()
        }
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
