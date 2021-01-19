//
//  SignUpViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/11.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpClassNumber: UITextField! {
        didSet {
            signUpClassNumber.layer.cornerRadius = 5
            signUpClassNumber.layer.borderWidth = 1
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
