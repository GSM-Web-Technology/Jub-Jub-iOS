//
//  SignUpPasswordViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/03/30.
//

import UIKit

class SignUpPasswordViewController: UIViewController {
    
    @IBOutlet weak var signUpPasswordTextField: UITextField! {
        didSet {
            signUpPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var signUpCheckPasswordTextField: UITextField! {
        didSet {
            signUpCheckPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var signUpPasswordBtn: UIButton! {
        didSet {
            signUpPasswordBtn.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var signUpPasswordBtnBottom: NSLayoutConstraint!
    
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

extension SignUpPasswordViewController: UITextFieldDelegate {
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            
            if self.signUpPasswordBtnBottom.constant == 25 {
                self.signUpPasswordBtnBottom.constant += (keyboardHeight - 20)
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if self.signUpPasswordBtnBottom.constant != 25 {
            self.signUpPasswordBtnBottom.constant = 25
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUpPasswordTextField.resignFirstResponder()
        signUpCheckPasswordTextField.resignFirstResponder()
        return true
    }
}
