//
//  SignUpNameViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/03/30.
//

import UIKit

class SignUpNameViewController: UIViewController {

    @IBOutlet weak var signUpNameTextField: UITextField! {
        didSet {
            signUpNameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var signUpNameBtn: UIButton! {
        didSet {
            signUpNameBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var signUpNameBtnBottom: NSLayoutConstraint!
    
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

extension SignUpNameViewController: UITextFieldDelegate {
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            
            if self.signUpNameBtnBottom.constant == 25 {
                self.signUpNameBtnBottom.constant += (keyboardHeight - 20)
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if self.signUpNameBtnBottom.constant != 25 {
            self.signUpNameBtnBottom.constant = 25
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUpNameTextField.resignFirstResponder()
        
        return true
    }
}
