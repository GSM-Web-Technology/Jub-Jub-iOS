//
//  MyPageViewController.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/02/21.
//

import UIKit
import Alamofire

class MyPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func signOutApiCall() {
        let URL = "http://15.165.97.179:8080/v2/logout"
        let token = KeychainManager.getToken()
        AF.request(URL, method: .post , headers: ["Authorization" : token]).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let dic = value as? NSDictionary {
                    if let success = dic["success"] as? Bool {
                        switch success {
                        case true:
                            KeychainManager.removeToken()
                            KeychainManager.removeEmail()
                            KeychainManager.removePassword()
                            self.goLoginPage()
                        default:
                            self.logOutFailAlert()
                        }
                    }
                }
            case . failure(let error):
                self.logOutFailAlert()
                print("\(error.localizedDescription)")
            }
            
        }
    }
    
    func logOutAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "로그아웃", style: .destructive) { (_) in
            self.signOutApiCall()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func logOutFailAlert() {
        let alert = UIAlertController(title: "로그아웃 실패!", message: "네트워크가 원활하지 않습니다.", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func goLoginPage(){
        guard let goMain = self.storyboard?.instantiateViewController(identifier: "LoginViewController") else { return }
        goMain.modalPresentationStyle = .fullScreen
        self.present(goMain, animated: true)
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        logOutAlert()
    }
}
