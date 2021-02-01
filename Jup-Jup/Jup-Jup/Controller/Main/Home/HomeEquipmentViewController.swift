//
//  HomeEquipmentViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/08.
//

import UIKit

class HomeEquipmentViewController: UIViewController {

    @IBOutlet weak var rentalCount: UILabel!
    @IBOutlet weak var equipmentCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func countStepper(_ sender: UIStepper) {
        
        rentalCount.text = "대여 수량: \(Int(sender.value))개"
        
    }
    
    func sucessAlert() {
        let alert = UIAlertController(title: "대여 성공", message: "대여 성공!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func failAlert() {
        let alert = UIAlertController(title: "대여 실패", message: "대여 실패!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        sucessAlert()
    }
    

}
