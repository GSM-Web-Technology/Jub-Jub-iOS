//
//  MyListReasonViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/03/02.
//

import UIKit

var reason = ""

class MyListReasonViewController: UIViewController {

    
    @IBOutlet weak var reasonView: UIView! {
        didSet {
            reasonView.clipsToBounds = true
            reasonView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var reasonLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reasonLabel.text = reason
        reasonLabel.sizeToFit()
    }
    
}
