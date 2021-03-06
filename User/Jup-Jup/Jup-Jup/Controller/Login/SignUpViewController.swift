//
//  SignUpViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/11.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class SignUpViewController: UIViewController {
    
    var failMessages = ""
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: .black, padding: 0)
    
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
        indicatorAutolayout()
        
    }
    
    func indicatorAutolayout() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
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
    
    func emailCheck() -> Bool {
        let regex = "s[0-9]+@gsm.hs.kr"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: signUpEmail.text)
    }
    
    func sucessAlert() {
        let alert = UIAlertController(title: "회원가입 성공", message: "이메일 인증을 해야 로그인이 가능합니다.", preferredStyle: UIAlertController.Style.alert)
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
        let URL = "http://15.165.97.179:8080/v2/signup"
        
        let PARAM: Parameters = [
            "classNumber": classNumber,
            "email": email,
            "name": name,
            "password": password
        ]
        
        AF.request(URL, method: .post, parameters: PARAM, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                if let dic = value as? NSDictionary {
                    if let code = dic["code"] as? Int {
                        switch code {
                        case 0:
                            self.indicator.stopAnimating()
                            self.sucessAlert()
                        case -1000:
                            self.indicator.stopAnimating()
                            self.failAlert(messages: "이미 가입된 이메일입니다.")
                        default:
                            return
                        }
                    }
                }
            case .failure(let e):
                self.indicator.stopAnimating()
                self.failAlert(messages: "네트워크가 원활하지 않습니다.")
                print(e.localizedDescription)
            }
        }
        
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if (checkTextField() && emailCheck()) {
            indicator.startAnimating()
            signUpApi(classNumber: signUpClassNumber.text!, email: signUpEmail.text!, name: signUpName.text!, password: signUpPassword.text!)
        } else {
            if !(checkTextField()) {
                failAlert(messages: failMessages)
            } else {
                failAlert(messages: "이메일 형식이 잘못되었습니다.")
            }
            
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

