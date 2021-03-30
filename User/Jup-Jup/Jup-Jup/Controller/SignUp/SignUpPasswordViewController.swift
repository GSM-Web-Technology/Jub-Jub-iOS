//
//  SignUpPasswordViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/03/30.
//

import UIKit

class SignUpPasswordViewController: UIViewController {

    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpCheckPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func checkTextField() -> Bool {
        if (signUpPasswordTextField.text == "" || signUpCheckPasswordTextField.text == "") {
            failAlert(messages: "빈칸을 모두 채워주세요.")
            return false
        } else {
            if signUpPasswordTextField.text == signUpCheckPasswordTextField.text {
                return true
            } else {
                failAlert(messages: "패스워드가 일치하지 않습니다.")
                return false
            }
        }
    }
    
    func failAlert(messages: String) {
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpPasswordContinueButton(_ sender: UIButton) {
        if (checkTextField()) {
            SignUpManager.savePassword(password: signUpPasswordTextField.text!)
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpNameViewController") as! SignUpNameViewController
            navigationController?.pushViewController(nextController, animated: true)
        }
    }
}
