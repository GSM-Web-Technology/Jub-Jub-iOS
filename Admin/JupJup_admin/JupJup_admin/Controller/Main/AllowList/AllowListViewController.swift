//
//  AllowListViewController.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/02/21.
//

import UIKit
import Alamofire

class AllowListViewController: UIViewController {
    
    var allowListModel: AllowListModel?

    @IBOutlet weak var allowListTableView: UITableView! {
        didSet {
            allowListTableView.delegate = self
            allowListTableView.dataSource = self
            allowListTableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allowListApiCall()
        
    }
    
    func allowListApiCall() {
        let URL = "http://15.165.97.179:8080/v2/admin/applyview"
        let token = KeychainManager.getToken()
        AF.request(URL, method: .get, headers: ["Authorization": token]).responseData { (data) in
            guard let data = data.data else { return }
            self.allowListModel = try? JSONDecoder().decode(AllowListModel.self, from: data)
            self.allowListTableView.reloadData()
            print(data)
        }
    }

}

extension AllowListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allowListModel?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllowListTableViewCell", for: indexPath) as! AllowListTableViewCell
        let cellCount = (allowListModel?.list.count)! - 1
        cell.allowListName.text = allowListModel?.list[cellCount - indexPath.row].equipment.name ?? ""
        cell.allowListContent.text = allowListModel?.list[cellCount - indexPath.row].equipment.content ?? ""
        cell.allowListCount.text = "수량: \(allowListModel?.list[cellCount - indexPath.row].amount ?? 0)개"
        let url = allowListModel?.list[cellCount - indexPath.row].equipment.img_equipment ?? ""
        let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        cell.allowListImage.kf.setImage(with: URL(string: encodingURL))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellCount = (allowListModel?.list.count)! - 1
        allowListContentTitle = allowListModel?.list[cellCount - indexPath.row].equipment.name ?? ""
        allowListContentStudentNameData = allowListModel?.list[cellCount - indexPath.row].admin.name ?? ""
        allowListContentImageData = allowListModel?.list[cellCount - indexPath.row].equipment.img_equipment ?? ""
        allowListContentReasonData = allowListModel?.list[cellCount - indexPath.row].reason ?? ""
        allowListContentClassNumberData = allowListModel?.list[cellCount - indexPath.row].admin.classNumber ?? ""
        allowListContentStudentEmailData = allowListModel?.list[cellCount - indexPath.row].admin.email ?? ""
        
    }
    
}
