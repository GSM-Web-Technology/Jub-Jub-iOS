//
//  HomeViewController.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/02/21.
//

import UIKit
import Alamofire
import Kingfisher

var menuSelected = true

class HomeViewController: UIViewController {
    
    var model: EquipmentModel?
    var searchModel: SearchModel?

    @IBOutlet weak var homeTableView: UITableView! {
        didSet {
            homeTableView.delegate = self
            homeTableView.dataSource = self
            homeTableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let equipmentNib = UINib(nibName: "HomeEquipmentTableViewCell", bundle: nil)
        let laptopNib = UINib(nibName: "HomeLaptopTableViewCell", bundle: nil)
        homeTableView.register(equipmentNib, forCellReuseIdentifier: "HomeEquipmentTableViewCell")
        homeTableView.register(laptopNib, forCellReuseIdentifier: "HomeLaptopTableViewCell")
        
        self.searchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    @IBAction func menuSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            menuSelected = true
            homeTableView.reloadData()
        } else {
            menuSelected = false
            homeTableView.reloadData()
        }
    }
    
    func apiCall() {
        let URL = "http://15.165.97.179:8080/v2/equipment/"
        let token = KeychainManager.getToken()
        AF.request(URL, method: .get, headers: ["Authorization": token]).responseData { (data) in
            guard let data = data.data else { return }
            self.model = try? JSONDecoder().decode(EquipmentModel.self, from: data)
            self.homeTableView.reloadData()
        }
    }
    
    func searchApiCall(name: String) {
        let URL = "http://15.165.97.179:8080/v2/equipment/findname/\(name)"
        let encodingURL = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let token = KeychainManager.getToken()
        AF.request(encodingURL, method: .get, headers: ["Authorization": token]).responseData { (data) in
            guard let data = data.data else { return }
            self.searchModel = try? JSONDecoder().decode(SearchModel.self, from: data)
            self.homeTableView.reloadData()
        }
    }
    
    func searchController() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
    }
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    func failAlert() {
        let alert = UIAlertController(title: "네트워크가 원활하지 않습니다.", message: "네트워크 확인 후 다시 접속해주세요.", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            exit(0)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCount = (model?.list.count)! - 1
        if menuSelected == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEquipmentTableViewCell", for: indexPath) as! HomeEquipmentTableViewCell
            if (isFiltering) {
                cell.equipmentName.text = searchModel?.data.name ?? ""
                cell.equipmentContent.text = searchModel?.data.content ?? ""
                cell.equipmentCount.text = "수량: \(searchModel?.data.count ?? 0)"
                let url = searchModel?.data.img_equipmentLocation ?? ""
                let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                cell.equipmentImage.kf.setImage(with: URL(string: encodingURL))
            } else {
                cell.equipmentName.text = model?.list[cellCount - indexPath.row].name ?? ""
                cell.equipmentContent.text = model?.list[cellCount - indexPath.row].content ?? ""
                cell.equipmentCount.text = "수량: \(model?.list[cellCount - indexPath.row].count ?? 0)"
                let url = model?.list[cellCount - indexPath.row].img_equipment ?? ""
                let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                cell.equipmentImage.kf.setImage(with: URL(string: encodingURL))
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeLaptopTableViewCell", for: indexPath) as! HomeLaptopTableViewCell
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchApiCall(name: searchController.searchBar.text!)
    }
}
