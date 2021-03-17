//
//  AllowListContentViewController.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/03/11.
//

import UIKit
import Kingfisher

var allowListContentTitle = ""
var allowListContentImageData = ""
var allowListContentStudentNameData = ""
var allowListContentClassNumberData = ""
var allowListContentStudentEmailData = ""
var allowListContentReasonData = ""
var allowListContentEquipmentIndexData = 0

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
    
    @IBAction func rejectButton(_ sender: Any) {
    }
    @IBAction func allowButton(_ sender: Any) {
    }
    

}
