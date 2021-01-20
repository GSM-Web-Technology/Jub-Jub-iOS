//
//  SignUpViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/11.
//

import UIKit

class SignUpViewController: UIViewController {

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
    
    @IBAction func signUpButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
