//
//  SignUpClassNumberViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/03/30.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class SignUpClassNumberViewController: UIViewController {

    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    
    @IBOutlet weak var signUpClassNumberTextField: UITextField!
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
        if signUpClassNumberTextField.text == "" {
            failAlert(messages: "빈칸을 모두 채워주세요.")
            return false
        } else {
            if (emailCheck()) {
                return true
            } else {
                failAlert(messages: "반, 번호를 제대로 입력해주세요.")
                return false
            }
        }
    }
    
    func emailCheck() -> Bool {
        let regex = "[0-9]{4}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: signUpClassNumberTextField.text)
    }

    func failAlert(messages: String) {
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    func sucessAlert() {
        let alert = UIAlertController(title: "회원가입 성공", message: "이메일 인증을 해야 로그인이 가능합니다.", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            SignUpManager.removeEmail()
            SignUpManager.removePassword()
            SignUpManager.removeName()
            self.navigationController?.popToRootViewController(animated: true)
        }
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
                            break
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
    
    
    @IBAction func signUpClassNumberDoneButton(_ sender: UIButton) {
        if (checkTextField()) {
            indicator.startAnimating()
            signUpApi(classNumber: signUpClassNumberTextField.text!, email: SignUpManager.getEmail(), name: SignUpManager.getName(), password: SignUpManager.getPassword())
        }
    }
}
