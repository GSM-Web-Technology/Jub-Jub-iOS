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
import NVActivityIndicatorView

class MyListViewController: UIViewController {
    
    var model: MyListModel?
    var refreshControl = UIRefreshControl()
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 75, height: 75), type: .ballPulse, color: .black, padding: 0)
    
    @IBOutlet weak var myListCollectionView: UICollectionView! {
        didSet {
            myListCollectionView.delegate = self
            myListCollectionView.dataSource = self
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
        
        myListCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        apiCall()
    }
    
    @objc func refresh() {
        myListCollectionView.reloadData()
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
    
    func apiCall() {
        let URL = "http://15.165.97.179:8080/v2/myequipment/"
        let token = KeychainManager.getToken()
        AF.request(URL,method: .get, headers: ["Authorization": token]).responseData(completionHandler: { data in
            guard let data = data.data else { return }
            self.model = try? JSONDecoder().decode(MyListModel.self, from: data)
            self.myListCollectionView.reloadData()
            self.indicator.stopAnimating()
            print(data)
        })
    }
}

extension MyListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.model?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyListCollectionViewCell", for: indexPath) as! MyListCollectionViewCell
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.backgroundColor = .white
        
        cell.layer.shadowColor = UIColor(red: 0.176, green: 0.341, blue: 0.627, alpha: 0.22).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        cell.myListAllowStatus.layer.cornerRadius = 12
        
        let cellCount = (model?.list.count)! - 1
        let url = model?.list[cellCount - indexPath.row].equipment.img_equipment ?? ""
        let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        cell.myListTitleName.text = model?.list[cellCount - indexPath.row].equipment.name ?? ""
        cell.myListContent.text = model?.list[cellCount - indexPath.row].equipment.content ?? ""
        cell.myListImageView.kf.setImage(with: URL(string: encodingURL))
        
        switch model?.list[cellCount - indexPath.row].equipmentEnum {
        case "ROLE_Waiting":
            cell.myListAllowStatus.text = "승인 대기"
            cell.myListAllowStatus.backgroundColor = .white
            cell.myListAllowStatus.textColor = UIColor.init(named: "Return Color")
            cell.myListAllowStatus.layer.borderWidth = 1
            cell.myListAllowStatus.layer.borderColor = UIColor.init(named: "Return Color")?.cgColor
        case "ROLE_Accept":
            cell.myListAllowStatus.text = "승인"
            cell.myListAllowStatus.backgroundColor = .white
            cell.myListAllowStatus.textColor = UIColor.init(named: "Approve Color")
            cell.myListAllowStatus.layer.borderWidth = 1
            cell.myListAllowStatus.layer.borderColor = UIColor.init(named: "Approve Color")?.cgColor
        case "ROLE_Rental":
            cell.myListAllowStatus.text = "대여"
            cell.myListAllowStatus.backgroundColor = .white
            cell.myListAllowStatus.textColor = UIColor.init(named: "Allow Color")
            cell.myListAllowStatus.layer.borderWidth = 1
            cell.myListAllowStatus.layer.borderColor = UIColor.init(named: "Allow Color")?.cgColor
        case "ROLE_Return":
            cell.myListAllowStatus.text = "반납"
            cell.myListAllowStatus.backgroundColor = .white
            cell.myListAllowStatus.textColor = UIColor.init(named: "Return Color")
            cell.myListAllowStatus.layer.borderWidth = 1
            cell.myListAllowStatus.layer.borderColor = UIColor.init(named: "Return Color")?.cgColor
        case "ROLE_Reject":
            cell.myListAllowStatus.text = "거절"
            cell.myListAllowStatus.backgroundColor = .white
            cell.myListAllowStatus.textColor = UIColor.init(named: "Reject Color")
            cell.myListAllowStatus.layer.borderWidth = 1
            cell.myListAllowStatus.layer.borderColor = UIColor.init(named: "Reject Color")?.cgColor
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
