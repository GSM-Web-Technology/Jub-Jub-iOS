//
//  KeychainManager.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/03/08.
//

import Foundation
import KeychainAccess

class KeychainManager {
    
    static let keychain = Keychain(service: "com.yourcompany.JupJup-admin")
    
    // token
    class func saveToken(token: String) {
        keychain["token"] = token
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
        keychain["email"] = email
    }
    
    class func getEmail() -> String {
        if let email = keychain["email"] {
            return email
        } else {
            return ""
        }
    }
    
    class func removeEmail() {
        keychain["email"] = nil
    }
    
    
    // password
    class func savePassword(password: String) {
        keychain["password"] = password
    }
    
    class func getPassword() -> String {
        if let password = keychain["password"] {
            return password
        } else {
            return ""
        }
    }
    
    class func removePassword() {
        keychain["password"] = nil
    }
    
}

