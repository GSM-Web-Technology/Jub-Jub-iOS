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
        let alamo = AF.request(URL, method: .get).validate(statusCode: 200..<300)
        //결과값으로 문자열을 받을 때 사용
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success(let value):
                print("value: \(value)")
//                }
                print("\(value)")
            //  self.sendImage(value: value)
            
            //통신실패
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
                //  self.resultLabel.text = "\(error)"
                print("\(error)")
            }
        }
//        let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        AF.request(encodingURL).responseData(completionHandler: { data in
//            guard let data = data.data else { return }
//            self.model = try? JSONDecoder().decode(Equipment.self, from: data)
//            self.homeTableView.reloadData()
//        })
        
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
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        return cell
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
    }
    
    
}
