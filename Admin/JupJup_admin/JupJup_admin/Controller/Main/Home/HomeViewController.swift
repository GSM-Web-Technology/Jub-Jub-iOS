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
    
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCount = (model?.list.count)! - 1
        if menuSelected == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEquipmentTableViewCell", for: indexPath) as! HomeEquipmentTableViewCell
            cell.equipmentName.text = model?.list[cellCount - indexPath.row].name ?? ""
            cell.equipmentContent.text = model?.list[cellCount - indexPath.row].content ?? ""
            cell.equipmentCount.text = "수량: \(model?.list[cellCount - indexPath.row].count ?? 0)"
            let url = model?.list[cellCount - indexPath.row].img_equipment ?? ""
            let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            cell.equipmentImage.kf.setImage(with: URL(string: encodingURL))
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
