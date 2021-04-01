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
    
    @IBOutlet weak var signUpClassNumberTextField: UITextField! {
        didSet {
            signUpClassNumberTextField.delegate = self
            signUpClassNumberTextField.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var signUpClassNumberBtn: UIButton! {
        didSet {
            signUpClassNumberBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var signUpClassNumberBtnBottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorAutolayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil )
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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

extension SignUpClassNumberViewController: UITextFieldDelegate {
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            
            if self.signUpClassNumberBtnBottom.constant == 25 {
                self.signUpClassNumberBtnBottom.constant += (keyboardHeight - 20)
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if self.signUpClassNumberBtnBottom.constant != 25 {
            self.signUpClassNumberBtnBottom.constant = 25
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUpClassNumberTextField.resignFirstResponder()
        
        return true
    }
}
