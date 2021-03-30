//
//  SignUpEmailViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/03/30.
//

import UIKit

class SignUpEmailViewController: UIViewController {

    @IBOutlet weak var signUpEmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func checkTextField() -> Bool {
        if signUpEmailTextField.text == "" {
            return false
        }
        
        return true
    }
    
    func emailCheck() -> Bool {
        let regex = "s[0-9]+@gsm.hs.kr"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: signUpEmailTextField.text)
    }

    @IBAction func signUpEmailContinueButton(_ sender: UIButton) {
        if checkTextField() && emailCheck() {
            SignUpManager.saveEmail(email: signUpEmailTextField.text!)
        }
        
    }
    
}
