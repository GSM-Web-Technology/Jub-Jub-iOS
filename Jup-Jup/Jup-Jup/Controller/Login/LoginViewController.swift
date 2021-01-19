//
//  LoginViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/11.
//

import UIKit



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
    
    @IBAction func logInButton(_ sender: UIButton) {
        goMainPage()
    }
    
    func goMainPage(){
        guard let goMain = self.storyboard?.instantiateViewController(identifier: "MainPage") else { return }
        goMain.modalPresentationStyle = .fullScreen
        self.present(goMain, animated: true)
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
