//
//  AllowListViewController.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/02/21.
//

import UIKit
import Alamofire

class AllowListViewController: UIViewController {

    @IBOutlet weak var allowListTableView: UITableView! {
        didSet {
            allowListTableView.delegate = self
            allowListTableView.dataSource = self
            allowListTableView.tableFooterView = UIView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func allowListApiCall() {
        let URL = "http://15.165.97.179:8080/v2/admin/applyview"
        let token = KeychainManager.getToken()
        AF.request(URL, method: .get, headers: ["Authorization": token]).responseData { (data) in
            guard let data = data.data else { return }
            
        }
    }

}

extension AllowListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllowListTableViewCell", for: indexPath) as! AllowListTableViewCell
        
        
        
        return cell
    }
    
    
}
