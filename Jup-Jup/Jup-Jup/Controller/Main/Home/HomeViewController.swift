//
//  HomeViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/07.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    var model: Equipment?
    
    @IBOutlet weak var homeTableView: UITableView! {
        didSet {
            homeTableView.delegate = self
            homeTableView.dataSource = self
            homeTableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    
    var arr = ["DC모터", "한성노트북", "삼성노트북", "모니터", "아두이노", "iPad", "갤럭시탭", "키보드", "마우스", "애플 매직마우스", "애플 매직키보드"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
        self.searchController()
    }
    
    func apiCall() {
        let URL = "http://3.36.29.69:8080/v1/equipment/"
        let encodingURL = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        AF.request(encodingURL, headers: ["X-AUTH-TOKEN": token]).responseData(completionHandler: { data in
            guard let data = data.data else { return }
            self.model = try? JSONDecoder().decode(Equipment.self, from: data)
            self.homeTableView.reloadData()
        })
        
    }
    
    func searchController() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func goMainPage(){
        guard let goMain = self.storyboard?.instantiateViewController(identifier: "MainPage") else { return }
        goMain.modalPresentationStyle = .fullScreen
        self.present(goMain, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.homeTitleName.text = model?.list[indexPath.row].name
        cell.homeSubName.text = model?.list[indexPath.row].content
        cell.homeCount.text = "수량: \(model?.list[indexPath.row].count ?? 0)개"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleName = model?.list[indexPath.row].name ?? ""
        content = model?.list[indexPath.row].content ?? ""
        count = model?.list[indexPath.row].count ?? 0

    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
    }
    
    
}
