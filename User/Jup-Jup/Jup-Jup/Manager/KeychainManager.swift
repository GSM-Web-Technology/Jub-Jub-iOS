//
//  TokenManager.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/02/22.
//

import Foundation
import KeychainAccess

class KeychainManager {
    
    static let keychain = Keychain(service: "com.yourcompany.Jup-Jup")
    
    // token
    class func saveToken(token: String) {
        keychain["token"] = "Bearer \(token)"
    }
    
    class func getToken() -> String {
        if let token = keychain["token"] {
            return token
        } else {
            return ""
        }
    }
    
    class func removeToken() {
        keychain["token"] = nil
    }
    
    
    // email
    class func saveEmail(email: String) {
        keychain["autoEmail"] = email
    }
    
    class func getEmail() -> String {
        if let email = keychain["autoEmail"] {
            return email
        } else {
            return ""
        }
    }
    
    class func removeEmail() {
        keychain["autoEmail"] = nil
    }
    
    
    // password
    class func savePassword(password: String) {
        keychain["autoPassword"] = password
    }
    
    class func getPassword() -> String {
        if let password = keychain["autoPassword"] {
            return password
        } else {
            return ""
        }
    }
    
    class func removePassword() {
        keychain["autoPassword"] = nil
    }
    
}
