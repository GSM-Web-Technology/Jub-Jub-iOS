//
//  NoticeViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/03/07.
//

import UIKit
import Alamofire

class NoticeViewController: UIViewController {
    
    var model: NoticeModel?

    @IBOutlet weak var noticeTableView: UITableView! {
        didSet {
            noticeTableView.delegate = self
            noticeTableView.dataSource = self
            noticeTableView.tableFooterView = UIView()
            noticeTableView.separatorInset.left = 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    func apiCall() {
        let URL = "http://15.165.97.179:8080/v2/notice"
        let token = KeychainManager.getToken()
        AF.request(URL, method: .get, headers: ["Authorization" : token]).responseData(completionHandler: { data in
            guard let data = data.data else { return }
            self.model = try? JSONDecoder().decode(NoticeModel.self, from: data)
            self.noticeTableView.reloadData()
            print(data)
        })
    }

}

extension NoticeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as! NoticeTableViewCell
        let cellCount = (model?.list.count)! - 1
        cell.noticeTitle.text = model?.list[cellCount - indexPath.row].title ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellCount = (model?.list.count)! - 1
        noticeTitleData = model?.list[cellCount - indexPath.row].title ?? ""
        noticeContentData = model?.list[cellCount - indexPath.row].content ?? ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
