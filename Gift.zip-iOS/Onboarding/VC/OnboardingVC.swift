//
//  OnboardingVC.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/04.
//

import UIKit
import AuthenticationServices

class OnboardingVC: UIViewController, ASAuthorizationControllerPresentationContextProviding ,ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    
    @IBOutlet weak var appleSignInBtn: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAppleSignInButton()
    }
    // Apple ID 로그인 버튼 생성
    func setAppleSignInButton() {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        authorizationButton.addTarget(self, action: #selector(appleSignInButtonPress), for: .touchUpInside)
        self.appleSignInBtn.addArrangedSubview(authorizationButton)
    }
    // Apple Login Button Pressed
    @objc func appleSignInButtonPress() {
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
                
            print("User ID : \(userIdentifier)")
            let SPREF = UserDefaults.standard
            SPREF.setValue("\(userIdentifier)", forKey: "appleId")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
     
        default:
            break
        }
    }
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //handle error
        print("apple ID 연동 실패 :  authorizationController() called ")
    }
}
