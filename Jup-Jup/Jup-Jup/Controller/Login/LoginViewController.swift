//
//  LoginViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/11.
//

import UIKit
import Alamofire


class LoginViewController: UIViewController {
    
    var failMessages = "로그인 실패!!"
    
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
    
    func loginFailAlert() {
        let alert = UIAlertController(title: "로그인 실패", message: "로그인 실패!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func checkTextField() -> Bool {
        if (logInEmail.text == "") || (logInPassword.text == "") {
            failMessages = "빈칸을 모두 입력해주세요!"
            return false
        }
        
        return true
    }
    
    func signInApi(email: String,password: String) {
        let URL = "http://3.36.29.69:8080/v1/signin"
        
        let PARAM: Parameters = [
            "email": email,
            "password": password
        ]
        
        let alamo = AF.request(URL, method: .post, parameters: PARAM,encoding: JSONEncoding.default).validate(statusCode: 200..<300)
        
        
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success(let value):
                self.loginSucessAlert()
                print("value: \(value)")
            //통신실패
            case .failure(let error):
                
                print("error: \(String(describing: error.errorDescription))")
                print("\(error)")
            }
        }
        
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        if (checkTextField()) {
            signInApi(email: logInEmail.text!, password: logInPassword.text!)
        } else {
            loginFailAlert()
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
