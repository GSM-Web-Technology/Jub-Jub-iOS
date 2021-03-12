//
//  AllowListContentViewController.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/03/11.
//

import UIKit

var allowListContentTitle = ""

class AllowListContentViewController: UIViewController {

    @IBOutlet weak var allowListContentImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = allowListContentTitle
    }

}
