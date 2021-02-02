//
//  HomeViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/07.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var homeTableView: UITableView! {
        didSet {
            homeTableView.delegate = self
            homeTableView.dataSource = self
            homeTableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigationBar에 검색란 넣기
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func searchTextField(_ sender: UITextField) {
        
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        return cell
    }
}


//extension HomeViewController: UISearchControllerDelegate {
//    func presentSearchController(_ searchController: UISearchController) {
//        searchController.obscuresBackgroundDuringPresentation = false
//        if searchController.searchBar.searchTextField.isSelected == true {
//            print("1")
//        }
//        select(true)
//    }
//
//    override func select(_ sender: Any?) {
//        print("1")
//    }
//}
