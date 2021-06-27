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

class HomeEquipmentViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 75, height: 75), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    var rentalAmount = 1
    
    @IBOutlet weak var equipmentName: UILabel!
    @IBOutlet weak var equipmentContent: UILabel!
    @IBOutlet weak var equipmentCount: UILabel! {
        didSet {
            equipmentCount.text = "수량: \(EquipmentManager.getEquipmentCount())개"
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
            stepper.maximumValue = Double(EquipmentManager.getEquipmentCount())
            stepper.labelFont = UIFont(name: "NotoSansKR-Light", size: 12)!
            stepper.buttonsFont = UIFont(name: "NotoSansKR-Light", size: 15)!
        }
    }
    @IBOutlet weak var reasonTextField: UITextField! {
        didSet {
            reasonTextField.delegate = self
            reasonTextField.addLeftPadding()
            let innerShadow = CALayer()
            innerShadow.frame = reasonTextField.bounds
            
            // Shadow path (1pt ring around bounds)
            let radius = 10
            let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: -1, dy: -1), cornerRadius:CGFloat(radius))
            let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius:CGFloat(radius)).reversing()
            
            
            path.append(cutout)
            innerShadow.shadowPath = path.cgPath
            innerShadow.masksToBounds = true
            // Shadow properties
            innerShadow.shadowColor = UIColor.init(named: "Primary Color")?.cgColor
            innerShadow.shadowOffset = CGSize(width: 1, height: 1)
            innerShadow.shadowOpacity = 1
            innerShadow.shadowRadius = 10
            innerShadow.cornerRadius = 10
            reasonTextField.layer.addSublayer(innerShadow)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorAutolayout()
        imageView.kf.setImage(with: URL(string: EquipmentManager.getEquipmentImgURL()))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Comfortaa-Regular_Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.init(named: "Primary Color")!]
        
        self.addKeyboardNotifications()
        
        equipmentName.text = EquipmentManager.getEquipmentTitle()
        equipmentContent.text = EquipmentManager.getEquipmentKind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.removeKeyboardNotifications()
        
    }
    
    @IBAction func countStepper(_ sender: GMStepper) {
        rentalAmount = Int(sender.value)
        print(rentalAmount)
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        if reasonTextField.text == "" {
            failAlert(message: "대여 사유를 적으십시오.")
        } else {
            checkAlert(name: EquipmentManager.getEquipmentTitle(), count: rentalAmount)
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
        let URL = "http://10.53.68.170:8081/v2/equipmentallow/\(name)"
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
            self.equipmentAllowAPI(amount: self.rentalAmount, reason: self.reasonTextField.text!, name: EquipmentManager.getEquipmentTitle())
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
    
    
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y -= (keyboardHeight-(self.tabBarController?.tabBar.frame.size.height)!)
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if view.frame.origin.y != 0.0 {
                self.view.frame.origin.y += (keyboardHeight-(self.tabBarController?.tabBar.frame.size.height)!)
                view.layoutIfNeeded()
            }
        }
    }
    
}

extension HomeEquipmentViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension UITextField {
   func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
