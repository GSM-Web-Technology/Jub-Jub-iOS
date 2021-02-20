//
//  MyPageViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/07.
//

import UIKit

class MyPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func goLoginPage(){
        guard let goMain = self.storyboard?.instantiateViewController(identifier: "LoginViewController") else { return }
        goMain.modalPresentationStyle = .fullScreen
        self.present(goMain, animated: true)
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        goLoginPage()
    }
}

