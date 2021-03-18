//
//  SceneDelegate.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/25.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
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
        
        NotificationCenter.default.post(name: .init("fromKakaoTalk"), object: dict)
        return true
    }
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            } else {
                
                NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .init("fromKakaoTalk"), object: nil)
                _ = parseQueryString(url.query)
            }
        }
    }
    
    @objc func handleNotification(_ notification: NSNotification) {
        if notification.name.rawValue == "fromKakaoTalk" {
            if let object = notification.object as? [String: String] {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let rootVC = self.window?.rootViewController as! UINavigationController
                    let vc = rootVC.viewControllers[0]
                    guard let detail = UIStoryboard.init(name: "Detail", bundle: nil).instantiateViewController(identifier: "DetailVC") as? DetailVC else { return }
                    detail.giftId = object["gift_id"]!
                    detail.modalPresentationStyle = .fullScreen
                    vc.present(detail, animated: true, completion: nil)
                }
            }
        }
    }
}

