//
//  MyListViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/07.
//

import UIKit

class MyListViewController: UIViewController {

    @IBOutlet weak var myListTableView: UITableView! {
        didSet {
            myListTableView.delegate = self
            myListTableView.dataSource = self
            myListTableView.tableFooterView = UIView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyListTableViewCell", for: indexPath) as! MyListTableViewCell
        switch indexPath.row % 2{
        case 1:
            cell.myListStatusLabel.backgroundColor = .yellow
            cell.myListStatusLabel.textColor = .black
            cell.myListStatusLabel.layer.borderWidth = 1
            cell.myListStatusLabel.text = "대여 중"
            return cell
        default:
            return cell
        }
//        return cell
    }
    
    
}
