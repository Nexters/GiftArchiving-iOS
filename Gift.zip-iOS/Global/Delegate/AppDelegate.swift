//
//  AppDelegate.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/25.
//

import UIKit
import AuthenticationServices
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (Notification) in
            print("Revoked Notification")
            let SPREF = UserDefaults.standard
            SPREF.setValue(nil, forKey: "appleId")
        }
        //kakao sdk 초기화
        KakaoSDKCommon.initSDK(appKey: "0beb54f6ec7d3aaba0e0940341a4ba9d")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func parseQueryString(_ query: String?) -> Bool {
        guard let query = query else { return false }
        
        var dict = [String: String]()
        let queryComponents = query.components(separatedBy: "&")
        
        for theComponent in queryComponents {
            let elements = theComponent.components(separatedBy: "=")
            guard let key = elements[0].removingPercentEncoding else { continue }
            guard let val = elements[1].removingPercentEncoding else { continue }
            
            dict[key] = val
        }
        
        if dict.count == 0 { return false }
        
        let SPREF = UserDefaults.standard
        SPREF.setValue(true, forKey: "checkFromKakaoTalk")
        
        NotificationCenter.default.post(name: .init("fromKakaoTalkToFirst"), object: dict)
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       
        return parseQueryString(url.query)
    }

}

