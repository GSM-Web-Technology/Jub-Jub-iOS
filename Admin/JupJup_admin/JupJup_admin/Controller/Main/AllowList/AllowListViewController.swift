//
//  AllowListViewController.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/02/21.
//

import UIKit

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
