//
//  SignUpViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/11.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    
    var failMessages = ""
    
    
    @IBOutlet weak var signUpEmail: UITextField! {
        didSet {
            signUpEmail.layer.cornerRadius = 5
            signUpEmail.layer.borderWidth = 1
            signUpEmail.delegate = self
        }
    }
    @IBOutlet weak var signUpPassword: UITextField! {
        didSet {
            signUpPassword.layer.cornerRadius = 5
            signUpPassword.layer.borderWidth = 1
            signUpPassword.delegate = self
        }
    }
    @IBOutlet weak var signUpPasswordCheck: UITextField! {
        didSet {
            signUpPasswordCheck.layer.cornerRadius = 5
            signUpPasswordCheck.layer.borderWidth = 1
            signUpPasswordCheck.delegate = self
        }
    }
    @IBOutlet weak var signUpName: UITextField! {
        didSet {
            signUpName.layer.cornerRadius = 5
            signUpName.layer.borderWidth = 1
            signUpName.delegate = self
        }
    }
    @IBOutlet weak var signUpClassNumber: UITextField! {
        didSet {
            signUpClassNumber.layer.cornerRadius = 5
            signUpClassNumber.layer.borderWidth = 1
            signUpClassNumber.delegate = self
        }
    }
    @IBOutlet weak var signUpBtn: UIButton! {
        didSet {
            signUpBtn.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.layer.cornerRadius = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func checkTextField() -> Bool {
        if (signUpEmail.text == "") || (signUpPassword.text == "") || (signUpPasswordCheck.text == "") || (signUpName.text == "") || (signUpClassNumber.text == "") {
            failMessages = "빈칸을 모두 입력해주세요!"
            return false
        } else if signUpPassword.text != signUpPasswordCheck.text {
            failMessages = "Password와 Password Check가 일치하지 않습니다!"
            return false
        }
        
        return true
    }
    
    func sucessAlert() {
        let alert = UIAlertController(title: "회원가입 성공", message: "회원가입 성공!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func failAlert(messages: String) {
        let alert = UIAlertController(title: "회원가입 실패", message: messages, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func signUpApi(classNumber: String, email: String, name: String, password: String) {
        let URL = "http://3.36.29.69:8080/v1/signup"
        
        let PARAM: Parameters = [
            "classNumber": classNumber,
            "email": email,
            "name": name,
            "password": password
        ]
        
        let alamo = AF.request(URL, method: .post, parameters: PARAM,encoding: JSONEncoding.default).validate(statusCode: 200..<300)
        
        
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success(let value):
                self.sucessAlert()
                print("value: \(value)")
            //통신실패
            case .failure(let error):
                self.failAlert(messages: self.failMessages)
                print("error: \(String(describing: error.errorDescription))")
                print("\(error)")
            }
        }
        
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if (checkTextField()) {
            signUpApi(classNumber: signUpClassNumber.text!, email: signUpEmail.text!, name: signUpName.text!, password: signUpPassword.text!)
        } else {
            failAlert(messages: failMessages)
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUpEmail.resignFirstResponder()
        signUpPassword.resignFirstResponder()
        signUpPasswordCheck.resignFirstResponder()
        signUpName.resignFirstResponder()
        signUpClassNumber.resignFirstResponder()
        return true
    }
}
