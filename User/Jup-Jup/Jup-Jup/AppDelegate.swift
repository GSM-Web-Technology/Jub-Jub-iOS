//
//  AppDelegate.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/02.
//

import UIKit
import Alamofire

var loginError = false

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if KeychainManager.keychain["autoEmail"] != nil {
            signInApi(email: KeychainManager.keychain["autoEmail"]!, password: KeychainManager.keychain["autoPassword"]!)
        }
        sleep(3)
        return true
    }
    
    func signInApi(email: String,password: String) {
        let URL = "http://10.53.68.170:8081/v2/signin"
        let PARAM: Parameters = [
            "email": email,
            "password": password
        ]
        AF.request(URL, method: .post, parameters: PARAM, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let dic = value as? NSDictionary {
                    if let code = dic["code"] as? Int {
                        switch code {
                        case 0:
                            if let allToken = dic["data"] as? NSDictionary {
                                if let token = allToken["AccessToken"] as? String {
                                    print(token)
                                    KeychainManager.saveToken(token: token)
                                }
                            }
                        default:
                            return
                        }
                    }
                }
            case .failure(let e):
                loginError = true
                print(e.localizedDescription)
            }
        }
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        KeychainManager.removeToken()
    }
}

