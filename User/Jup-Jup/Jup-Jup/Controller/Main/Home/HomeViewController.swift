//
//  HomeViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/07.
//

import UIKit
import Alamofire
import Kingfisher
import NVActivityIndicatorView


class HomeViewController: UIViewController, UITextFieldDelegate {
    
    var model: EquipmentModel?
    var searchModel: SearchModel?
    var refreshControl = UIRefreshControl()
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 75, height: 75), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    
    @IBOutlet weak var homeCollectionView: UICollectionView! {
        didSet {
            homeCollectionView.delegate = self
            homeCollectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.clipsToBounds = true
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        
        indicatorAutolayout()
        indicator.startAnimating()
        if check == true {
            self.searchController()
            apiCall()
        }
        homeCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if check == false {
            self.apiCall()
            self.searchController()
        }
        
    }
    
    @objc func refresh() {
        homeCollectionView.reloadData()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(refreshControl.isRefreshing) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.refreshControl.endRefreshing()
                self.apiCall()
            }
            
        }
    }
    
    func indicatorAutolayout() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
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
            self.homeCollectionView.reloadData()
            self.indicator.stopAnimating()
        })
    }
    
    func searchApiCall(name: String) {
        let URL = "http://15.165.97.179:8080/v2/equipment/findname/\(name)"
        let encodingURL = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let token = KeychainManager.getToken()
        AF.request(encodingURL, method: .get, headers: ["Authorization": token]).responseData(completionHandler: { data in
            guard let data = data.data else { return }
            self.searchModel = try? JSONDecoder().decode(SearchModel.self, from: data)
            self.homeCollectionView.reloadData()
            print(data)
        })
    }
    
    func searchController() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "검색"
    }
}



extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchApiCall(name: searchController.searchBar.text!)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (isFiltering) {
            return self.searchModel?.data.cellCount ?? 0
        } else {
            return self.model?.list.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.backgroundColor = .white
        
        cell.layer.shadowColor = UIColor(red: 0.176, green: 0.341, blue: 0.627, alpha: 0.22).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        let cellCount = (model?.list.count)! - 1
        if self.isFiltering {
            cell.homeTitleName.text = searchModel?.data.name ?? ""
            cell.homeContentName.text = searchModel?.data.content ?? ""
            cell.homeAmount.text = "수량: \(searchModel?.data.count ?? 0)개"
            let url = searchModel?.data.img_equipmentLocation ?? ""
            let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            cell.homeImageView.kf.setImage(with: URL(string: encodingURL))
        } else {
            cell.homeTitleName.text = model?.list[cellCount - indexPath.row].name ?? ""
            cell.homeContentName.text = model?.list[cellCount - indexPath.row].content ?? ""
            cell.homeAmount.text = "수량: \(model?.list[cellCount - indexPath.row].count ?? 0)개"
            let url = model?.list[cellCount - indexPath.row].img_equipment ?? ""
            let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            cell.homeImageView.kf.setImage(with: URL(string: encodingURL))
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellCount = (model?.list.count)! - 1
        if self.isFiltering {
            titleName = searchModel?.data.name ?? ""
            count = searchModel?.data.count ?? 0
            let url = searchModel?.data.img_equipmentLocation ?? ""
            let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            imgURL = encodingURL
        } else {
            titleName = model?.list[cellCount - indexPath.row].name ?? ""
            count = model?.list[cellCount - indexPath.row].count ?? 0
            let url = model?.list[cellCount - indexPath.row].img_equipment ?? ""
            let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            imgURL = encodingURL
        }
    }
    
    
}
