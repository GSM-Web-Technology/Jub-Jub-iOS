//
//  HomeViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/07.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    var menu = Bool()
    var model: Equipment?
    var searchModel: Search?
    var filteredArr: [String] = []
    
    @IBOutlet weak var homeTableView: UITableView! {
        didSet {
            homeTableView.delegate = self
            homeTableView.dataSource = self
            homeTableView.tableFooterView = UIView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        apiCall()
        self.searchController()
    }
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    func apiCall() {
        let URL = "http://3.36.29.69:8080/v1/equipment/"
        AF.request(URL, headers: ["X-AUTH-TOKEN": token]).responseData(completionHandler: { data in
            guard let data = data.data else { return }
            self.model = try? JSONDecoder().decode(Equipment.self, from: data)
            self.homeTableView.reloadData()
        })
    }
    
    func searchApiCall(word: String) {
        let URL = "http://3.36.29.69:8080/v1/equipment/\(word)"
        let encodingURL = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        AF.request(encodingURL, headers: ["X-AUTH-TOKEN": token]).responseData(completionHandler: { data in
            guard let data = data.data else { return }
            self.searchModel = try? JSONDecoder().decode(Search.self, from: data)
            print(data)
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
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isFiltering) {
            return self.searchModel?.data.cellCount ?? 0
        } else {
            return self.model?.list.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        if self.isFiltering {
            cell.homeTitleName.text = searchModel?.data.name ?? ""
            cell.homeSubName.text = searchModel?.data.content ?? ""
            cell.homeCount.text = "수량: \(searchModel?.data.count ?? 0)개"
        } else {
            cell.homeTitleName.text = model?.list[indexPath.row].name ?? ""
            cell.homeSubName.text = model?.list[indexPath.row].content ?? ""
            cell.homeCount.text = "수량: \(model?.list[indexPath.row].count ?? 0)개"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isFiltering {
            titleName = searchModel?.data.name ?? ""
            count = searchModel?.data.count ?? 0
        } else {
            titleName = model?.list[indexPath.row].name ?? ""
            count = model?.list[indexPath.row].count ?? 0
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchApiCall(word: searchController.searchBar.text!)
    }
}
