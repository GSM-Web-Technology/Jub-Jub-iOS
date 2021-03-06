//
//  MyListViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/07.
//

import UIKit
import Alamofire
import Kingfisher
import SemiModalViewController

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        apiCall()
    }
    
    func apiCall() {
        let URL = "http://15.165.97.179:8080/v2/myequipment/"
        let token = KeychainManager.getToken()
        AF.request(URL,method: .get, headers: ["Authorization": token]).responseData(completionHandler: { data in
            guard let data = data.data else { return }
            self.model = try? JSONDecoder().decode(MyListModel.self, from: data)
            self.myListTableView.reloadData()
            print(data)
        })
    }
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyListTableViewCell", for: indexPath) as! MyListTableViewCell
        let cellCount = (model?.list.count)! - 1
        cell.myListTitleName.text = model?.list[cellCount - indexPath.row].equipment.name ?? ""
        cell.myListSubName.text = model?.list[cellCount - indexPath.row].equipment.content ?? ""
        cell.myListCount.text = "대여 수량: \(model?.list[cellCount - indexPath.row].amount ?? 0)개"
        let url = URL(string: model?.list[cellCount - indexPath.row].equipment.img_equipment ?? "")
        cell.myListImageView.kf.setImage(with: url)
        
        switch model?.list[cellCount - indexPath.row].equipmentEnum {
        case "ROLE_Waiting":
            cell.myListStatusLabel.text = "승인 대기"
            cell.myListStatusLabel.backgroundColor = .yellow
            cell.myListStatusLabel.textColor = .black
            cell.myListStatusLabel.layer.borderWidth = 1
        case "ROLE_Accept":
            cell.myListStatusLabel.text = "승인"
            cell.myListStatusLabel.backgroundColor = .white
            cell.myListStatusLabel.textColor = .black
            cell.myListStatusLabel.layer.borderWidth = 1
        case "ROLE_Rental":
            cell.myListStatusLabel.text = "대여"
            cell.myListStatusLabel.backgroundColor = .white
            cell.myListStatusLabel.textColor = .black
            cell.myListStatusLabel.layer.borderWidth = 1
        case "ROLE_Return":
            cell.myListStatusLabel.text = "반납"
            cell.myListStatusLabel.backgroundColor = .white
            cell.myListStatusLabel.textColor = .black
            cell.myListStatusLabel.layer.borderWidth = 1
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: MyListReasonViewController.self)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        let cellCount = (model?.list.count)! - 1
        controller.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
        
        reason = self.model?.list[cellCount - indexPath.row].reason ?? ""
        presentSemiViewController(controller, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
            print("Dismissed!")
        })
        
    }
    
    
}
