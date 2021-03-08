//
//  NoticeContentViewController.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/03/08.
//

import UIKit

var noticeTitleData = ""
var noticeContentData = ""

class NoticeContentViewController: UIViewController {

    @IBOutlet weak var noticeContent: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = noticeTitleData
        noticeContent.text = noticeContentData
        noticeContent.sizeToFit()
    }
}
