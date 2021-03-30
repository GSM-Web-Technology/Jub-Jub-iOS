//
//  SignUpNameViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/03/30.
//

import UIKit

class SignUpNameViewController: UIViewController {

    @IBOutlet weak var signUpNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func checkTextField() -> Bool {
        if signUpNameTextField.text == "" {
            failAlert(messages: "빈칸을 모두 채워주세요.")
            return false
        }
        return true
    }
    
    func failAlert(messages: String) {
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpNameContinueButton(_ sender: UIButton) {
        if (checkTextField()) {
            SignUpManager.saveName(name: signUpNameTextField.text!)
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpClassNumberViewController") as! SignUpClassNumberViewController
            navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
}
