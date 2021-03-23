//
//  HomeEquipmentViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/08.
//

import UIKit
import Alamofire
import Kingfisher
import NVActivityIndicatorView
import GMStepper

var titleName: String?
var content: String?
var imgURL: String?
var count: Int?

class HomeEquipmentViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 75, height: 75), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    var rentalAmount = 1
    
    @IBOutlet weak var equipmentCount: UILabel! {
        didSet {
            equipmentCount.text = "수량: \(count!)개"
            equipmentCount.layer.borderWidth = 1
            equipmentCount.layer.borderColor = UIColor.init(named: "Primary Color")?.cgColor
            equipmentCount.layer.cornerRadius = 13
        }
    }
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var stepper: GMStepper! {
        didSet {
            stepper.minimumValue = 1
            stepper.maximumValue = Double(count!)
            stepper.labelFont = UIFont(name: "NotoSansKR-Light", size: 12)!
            stepper.buttonsFont = UIFont(name: "NotoSansKR-Light", size: 15)!
        }
    }
    @IBOutlet weak var reasonTextField: UITextField! {
        didSet {
            reasonTextField.delegate = self
            reasonTextField.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorAutolayout()
        imageView.kf.setImage(with: URL(string: imgURL ?? ""))
    }
    
    @IBAction func countStepper(_ sender: GMStepper) {
        rentalAmount = Int(sender.value)
        print(rentalAmount)
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        if reasonTextField.text == "" {
            failAlert(message: "대여 사유를 적으십시오.")
        } else {
            checkAlert(name: titleName!, count: rentalAmount)
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
    
    func equipmentAllowAPI(amount: Int, reason: String, name: String) {
        let URL = "http://15.165.97.179:8080/v2/equipmentallow/\(name)"
        let encodingURL = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let PARAM: Parameters = [
            "amount": amount,
            "reason": reason
        ]
        let token = KeychainManager.getToken()
        
        AF.request(encodingURL, method: .post, parameters: PARAM,encoding: JSONEncoding.default, headers: ["Authorization": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let dic = value as? NSDictionary {
                    if let success = dic["success"] as? Bool {
                        switch success {
                        case true:
                            self.indicator.stopAnimating()
                            self.successAlert()
                        case false:
                            self.indicator.stopAnimating()
                            self.failAlert(message: "대여 실패!")
                        }
                    }
                }
            case .failure(let e):
                self.indicator.stopAnimating()
                self.failAlert(message: "네트워크가 원활하지 않습니다.")
                print(e.localizedDescription)
            }
        }
    }
    
    func successAlert() {
        let alert = UIAlertController(title: "대여 신청 완료", message: "대여 신청되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    func checkAlert(name: String, count: Int) {
        let alert = UIAlertController(title: "\(name) \(count)개", message: "대여 신청하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.indicator.startAnimating()
            self.equipmentAllowAPI(amount: self.rentalAmount, reason: self.reasonTextField.text!, name: titleName!)
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func failAlert(message: String) {
        let alert = UIAlertController(title: "대여 실패", message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension HomeEquipmentViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
