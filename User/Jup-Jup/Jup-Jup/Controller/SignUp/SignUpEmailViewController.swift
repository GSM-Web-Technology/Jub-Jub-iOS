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

    func failAlert(messages: String) {
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpEmailContinueButton(_ sender: UIButton) {
        if (checkTextField() && emailCheck()) {
            SignUpManager.saveEmail(email: signUpEmailTextField.text!)
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpPasswordViewController") as! SignUpPasswordViewController
            navigationController?.pushViewController(nextController, animated: true)
        } else if !(checkTextField()) {
            failAlert(messages: "빈칸을 모두 채우세요.")
        } else {
            failAlert(messages: "이메일 형식이 맞지 않습니다.")
        }
        
    }
    
}
