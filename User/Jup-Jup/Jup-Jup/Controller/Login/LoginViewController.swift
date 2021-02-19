//
//  LoginViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/11.
//

import UIKit
import Alamofire

var token = String()

class LoginViewController: UIViewController {

    
    
    @IBOutlet weak var logInEmail: UITextField! {
        didSet {
            logInEmail.layer.cornerRadius = 5
            logInEmail.layer.borderWidth = 1
            logInEmail.delegate = self
        }
    }
    
    @IBOutlet weak var logInPassword: UITextField! {
        didSet {
            logInPassword.layer.cornerRadius = 5
            logInPassword.layer.borderWidth = 1
            logInPassword.delegate = self
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
    
    func goMainPage(){
        guard let goMain = self.storyboard?.instantiateViewController(identifier: "MainPage") else { return }
        goMain.modalPresentationStyle = .fullScreen
        self.present(goMain, animated: true)
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
    
    func checkTextField() -> Bool {
        if (logInEmail.text == "") || (logInPassword.text == "") {
            return false
        }
        return true
    }
    
    func signInApi(email: String,password: String) {
        let URL = "http://15.165.97.179:8080/v2/signin"
        let PARAM: Parameters = [
            "email": email,
            "password": password
        ]
        
        AF.request(URL, method: .post, parameters: PARAM,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let dic = value as? NSDictionary {
                    if let code = dic["code"] as? Int {
                        switch code {
                        case 0:
                            if let allToken = dic["data"] as? NSDictionary {
                                if let accessToken = allToken["accessToken"] as? String {
                                    print(accessToken)
                                    token = accessToken
                                }
                            }
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
    
    @IBAction func logInButton(_ sender: UIButton) {
        if (checkTextField()) {
            signInApi(email: logInEmail.text!, password: logInPassword.text!)
        } else {
            loginFailAlert(messages: "빈칸을 모두 채워주세요.")
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        logInEmail.resignFirstResponder()
        logInPassword.resignFirstResponder()
        
        return true
    }
}