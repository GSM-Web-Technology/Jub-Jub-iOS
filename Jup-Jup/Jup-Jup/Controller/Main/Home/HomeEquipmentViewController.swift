//
//  HomeEquipmentViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/08.
//

import UIKit
import Alamofire

var titleName = String()
var content = String()
var count = Int()

class HomeEquipmentViewController: UIViewController {
    
    var rentalAmount = 1

    @IBOutlet weak var equipmentCount: UILabel! {
        didSet {
            equipmentCount.text = "수량: \(count)개"
        }
    }
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var stepper: UIStepper! {
        didSet {
            stepper.minimumValue = 1
            stepper.maximumValue = Double(count)
        }
    }
    @IBOutlet weak var reasonTextView: UITextView! {
        didSet {
            reasonTextView.layer.cornerRadius = 5
            reasonTextView.delegate = self
        }
    }
    @IBOutlet weak var rentalCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleName
    }
    
    @IBAction func countStepper(_ sender: UIStepper) {
        rentalAmount = Int(sender.value)
        rentalCount.text = "대여 수량: \(rentalAmount)개"
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        if reasonTextView.text == "" {
            failAlert(message: "대여 사유를 적으십시오.")
        } else {
            equipmentAllowAPI(amount: rentalAmount, reason: reasonTextView.text, name: titleName)
        }
        
        
    }
    
    func equipmentAllowAPI(amount: Int, reason: String, name: String) {
        let URL = "http://3.36.29.69:8080/v1/equipmentallow/\(name)"
        let encodingURL = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let PARAM: Parameters = [
            "amount": amount,
            "reason": reason
        ]
        print(token)
        let alamo = AF.request(encodingURL, method: .post, parameters: PARAM, encoding: JSONEncoding.default, headers: ["X-AUTH-TOKEN": token]).validate(statusCode: 200...300)
        
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success(let value):
                print("value: \(value)")
                print("\(value)")
            
            //통신실패
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
                //  self.resultLabel.text = "\(error)"
                print("\(error)")
            }
        }

    }
    
    func sucessAlert() {
        let alert = UIAlertController(title: "대여 성공", message: "대여 성공!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func failAlert(message: String) {
        let alert = UIAlertController(title: "대여 실패", message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension HomeEquipmentViewController: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
