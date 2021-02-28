//
//  HomeViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/07.
//

import UIKit
import Alamofire
import Kingfisher
import SkeletonView


class HomeViewController: UIViewController, UITextFieldDelegate {
    
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
        //        if check == true {
        //            self.searchController()
        //            apiCall()
        //        }
        homeTableView.rowHeight = 120
        homeTableView.estimatedRowHeight = 120
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.homeTableView.isSkeletonable = true
        self.homeTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .link), animation: nil, transition: .crossDissolve(0.25))
        
        self.apiCall()
        self.searchController()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.homeTableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        }
        
        
        
    }
    
    func failAlert() {
        let alert = UIAlertController(title: "네트워크가 원활하지 않습니다.", message: "네트워크 확인 후 다시 접속해주세요.", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            exit(0)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    func apiCall() {
        let URL = "http://15.165.97.179:8080/v2/equipment/"
        let token = KeychainManager.getToken()
        AF.request(URL, headers: ["Authorization": token]).responseData(completionHandler: { data in
            guard let data = data.data else { return }
            self.model = try? JSONDecoder().decode(EquipmentModel.self, from: data)
            self.homeTableView.reloadData()
        })
    }
    
    func searchApiCall(word: String) {
        let URL = "http://15.165.97.179:8080/v2/equipment/\(word)"
        let encodingURL = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let token = KeychainManager.getToken()
        AF.request(encodingURL, method: .get, headers: ["Authorization": token]).responseData(completionHandler: { data in
            guard let data = data.data else { return }
            self.searchModel = try? JSONDecoder().decode(SearchModel.self, from: data)
            self.homeTableView.reloadData()
            print(data)
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

extension HomeViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
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
        let cellCount = (model?.list.count)! - 1
        if self.isFiltering {
            cell.homeTitleName.text = searchModel?.data.name ?? ""
            cell.homeSubName.text = searchModel?.data.content ?? ""
            cell.homeCount.text = "수량: \(searchModel?.data.count ?? 0)개"
            let url = URL(string: searchModel?.data.img_equipmentLocation ?? "")
            cell.homeImageView.kf.setImage(with: url)
        } else {
            cell.homeTitleName.text = model?.list[cellCount - indexPath.row].name ?? ""
            cell.homeSubName.text = model?.list[cellCount - indexPath.row].content ?? ""
            cell.homeCount.text = "수량: \(model?.list[cellCount - indexPath.row].count ?? 0)개"
            let url = URL(string: model?.list[cellCount - indexPath.row].img_equipment ?? "")
            cell.homeImageView.kf.setImage(with: url)
        }
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "HomeTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellCount = (model?.list.count)! - 1
        if self.isFiltering {
            titleName = searchModel?.data.name ?? ""
            count = searchModel?.data.count ?? 0
            let url = URL(string: searchModel?.data.img_equipmentLocation ?? "")
            imgURL = url
        } else {
            titleName = model?.list[cellCount - indexPath.row].name ?? ""
            count = model?.list[cellCount - indexPath.row].count ?? 0
            let url = URL(string: model?.list[cellCount - indexPath.row].img_equipment ?? "")
            imgURL = url
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchApiCall(word: searchController.searchBar.text!)
    }
}
