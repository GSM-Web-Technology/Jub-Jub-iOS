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
            let innerShadow = CALayer()
            innerShadow.frame = reasonView.bounds
            
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
            reasonView.layer.addSublayer(innerShadow)
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
