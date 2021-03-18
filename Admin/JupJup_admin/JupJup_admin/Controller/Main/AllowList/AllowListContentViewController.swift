//
//  AllowListContentViewController.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/03/11.
//

import UIKit
import Alamofire
import Kingfisher

var allowListContentTitle = ""
var allowListContentImageData = ""
var allowListContentStudentNameData = ""
var allowListContentClassNumberData = ""
var allowListContentStudentEmailData = ""
var allowListContentReasonData = ""
var allowListContentEquipmentIndexData = 0
var allowListContentEquipmentAmountData = 0

class AllowListContentViewController: UIViewController {

    @IBOutlet weak var allowListContentImage: UIImageView!
    @IBOutlet weak var allowListContentStudentName: UILabel!
    @IBOutlet weak var allowListContentClassNumber: UILabel!
    @IBOutlet weak var allowListContentStudentEmail: UILabel!
    @IBOutlet weak var allowListContentReason: UILabel!
    @IBOutlet weak var rejectBtn: UIButton! {
        didSet {
            rejectBtn.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var allowBtn: UIButton! {
        didSet {
            allowBtn.layer.cornerRadius = 5
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let encodingURL = allowListContentImageData.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        title = allowListContentTitle
        allowListContentImage.kf.setImage(with: URL(string: encodingURL))
        allowListContentStudentName.text = allowListContentStudentNameData
        allowListContentClassNumber.text = allowListContentClassNumberData
        allowListContentStudentEmail.text = allowListContentStudentEmailData
        allowListContentReason.text = allowListContentReasonData
        
    }
    
    func allowApiCall(eqa_Idx: Int) {
        let URL = "http://15.165.97.179:8080/v2/admin/approved/\(eqa_Idx)"
        let token = KeychainManager.getToken()
        
        AF.request(URL, method: .put, headers: ["Authorization": token]).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let dic = value as? NSDictionary {
                    if let success = dic["success"] as? Bool {
                        switch success {
                        case true:
                            self.successAlert(name: allowListContentTitle, amount: allowListContentEquipmentAmountData)
                        default:
                            self.failAlert(message: "승인 실패하였습니다.")
                        }
                    }
                }
            case .failure(let error):
                self.failAlert(message: "네트워크가 원활하지 않습니다.")
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func checkAlert(name: String, amount: Int) {
        let alert = UIAlertController(title: "\(name) \(amount)개", message: "승인하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { (_) in
            self.allowApiCall(eqa_Idx: allowListContentEquipmentIndexData)
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func successAlert(name: String, amount: Int) {
        let alert = UIAlertController(title: "\(name) \(amount)개", message: "승인되었습니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func failAlert(message: String) {
        let alert = UIAlertController(title: "승인 실패!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func rejectButton(_ sender: Any) {
    }
    @IBAction func allowButton(_ sender: Any) {
        checkAlert(name: allowListContentTitle, amount: allowListContentEquipmentAmountData)
    }
    

}
