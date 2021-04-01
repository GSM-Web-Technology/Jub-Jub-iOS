//
//  SignUpEmailViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/03/30.
//

import UIKit

class SignUpEmailViewController: UIViewController {
    
    @IBOutlet weak var signUpEmailTextField: UITextField! {
        didSet {
            signUpEmailTextField.delegate = self
            signUpEmailTextField.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var signUpEmailBtn: UIButton! {
        didSet {
            signUpEmailBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var signUpEmailBtnBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

extension SignUpEmailViewController: UITextFieldDelegate {
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            
            if self.signUpEmailBtnBottom.constant == 25 {
                self.signUpEmailBtnBottom.constant += keyboardHeight
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if self.signUpEmailBtnBottom.constant != 25 {
            self.signUpEmailBtnBottom.constant = 25
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUpEmailTextField.resignFirstResponder()
        return true
    }
}
