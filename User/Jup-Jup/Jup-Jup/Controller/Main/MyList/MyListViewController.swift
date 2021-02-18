//
//  MyListViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/07.
//

import UIKit
import Alamofire

class MyListViewController: UIViewController {

    var model: MyListModel?
    
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

    func apiCall() {
        let URL = "http://3.36.29.69:8080/v2/myequipment/"
        AF.request(URL, headers: ["X-AUTH-TOKEN": token]).responseData(completionHandler: { data in
            guard let data = data.data else { return }
            self.model = try? JSONDecoder().decode(MyListModel.self, from: data)
            self.myListTableView.reloadData()
        })
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
        return cell
    }
    
    
}
