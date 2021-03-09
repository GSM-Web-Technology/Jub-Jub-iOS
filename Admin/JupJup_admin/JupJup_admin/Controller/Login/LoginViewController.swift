//
//  LoginViewController.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/02/19.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var logInEmailTextField: UITextField! {
        didSet {
            logInEmailTextField.layer.cornerRadius = 5
            logInEmailTextField.layer.borderWidth = 1
            logInEmailTextField.delegate = self
        }
    }
    
    @IBOutlet weak var logInPasswordTextField: UITextField! {
        didSet {
            logInPasswordTextField.layer.cornerRadius = 5
            logInPasswordTextField.layer.borderWidth = 1
            logInPasswordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var logInBtn: UIButton! {
        didSet {
            logInBtn.layer.cornerRadius = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func logInButton(_ sender: UIButton) {
        if (checkTextField()) {
            apiCall(email: logInEmailTextField.text!, password: logInPasswordTextField.text!)
        } else {
            loginFailAlert(messages: "빈칸을 모두 채워주세요.")
        }
    }
    
    func checkTextField() -> Bool {
        if (logInEmailTextField.text == "") || (logInPasswordTextField.text == "") {
            return false
        }
        return true
    }
    
    func goMainPage(){
        guard let goMain = self.storyboard?.instantiateViewController(identifier: "MainPage") else { return }
        goMain.modalPresentationStyle = .fullScreen
        self.present(goMain, animated: true)
    }
    
    func apiCall(email: String,password: String) {
        let URL = "http://15.165.97.179:8080/v2/signin"
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
                                if let token = allToken["accessToken"] as? String {
                                    print(token)
                                    KeychainManager.saveToken(token: token)
                                }
                            }
                            KeychainManager.saveEmail(email: self.logInEmailTextField.text!)
                            KeychainManager.savePassword(password: self.logInPasswordTextField.text!)
                            self.loginSucessAlert()
                        case -1001:
                            self.loginFailAlert(messages: "계정이 존재하지 않거나 이메일 또는 비밀번호가 정확하지 않습니다.")
                        case -947:
                            self.loginFailAlert(messages: "이메일 인증을 해주세요!")
                        default:
                            return
                        }
                    }
                }
            case .failure(let e):
                self.loginFailAlert(messages: "네트워크가 원활하지 않습니다.")
                print(e.localizedDescription)
            }
        }
    }
    
    func loginSucessAlert() {
        let alert = UIAlertController(title: "로그인 성공", message: "로그인 성공!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.goMainPage()
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func loginFailAlert(messages: String) {
        let alert = UIAlertController(title: "로그인 실패", message: messages, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    

}

extension LoginViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        logInEmailTextField.resignFirstResponder()
        logInPasswordTextField.resignFirstResponder()
        
        return true
    }
}
