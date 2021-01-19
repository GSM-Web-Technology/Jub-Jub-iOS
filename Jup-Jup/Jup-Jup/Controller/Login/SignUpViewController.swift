//
//  SignUpViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/11.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var SignUpEmail: UITextField! {
        didSet {
            SignUpEmail.layer.cornerRadius = 5
            SignUpEmail.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var SignUpPassword: UITextField! {
        didSet {
            SignUpPassword.layer.cornerRadius = 5
            SignUpPassword.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var SignUpPasswordCheck: UITextField! {
        didSet {
            SignUpPasswordCheck.layer.cornerRadius = 5
            SignUpPasswordCheck.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var SignUpName: UITextField! {
        didSet {
            SignUpName.layer.cornerRadius = 5
            SignUpName.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var signUpClassNumber: UITextField! {
        didSet {
            signUpClassNumber.layer.cornerRadius = 5
            signUpClassNumber.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var signUpBtn: UIButton! {
        didSet {
            signUpBtn.layer.cornerRadius = 5
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}
