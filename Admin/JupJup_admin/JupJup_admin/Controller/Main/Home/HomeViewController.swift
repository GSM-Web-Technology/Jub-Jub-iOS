//
//  HomeViewController.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/02/21.
//

import UIKit

var menuSelected = true

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView! {
        didSet {
            homeTableView.delegate = self
            homeTableView.dataSource = self
            homeTableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let equipmentNib = UINib(nibName: "HomeEquipmentTableViewCell", bundle: nil)
        let laptopNib = UINib(nibName: "HomeLaptopTableViewCell", bundle: nil)
        homeTableView.register(equipmentNib, forCellReuseIdentifier: "HomeEquipmentTableViewCell")
        homeTableView.register(laptopNib, forCellReuseIdentifier: "HomeLaptopTableViewCell")
    }
    
    @IBAction func menuSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            menuSelected = true
            homeTableView.reloadData()
        } else {
            menuSelected = false
            homeTableView.reloadData()
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if menuSelected == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEquipmentTableViewCell", for: indexPath) as! HomeEquipmentTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeLaptopTableViewCell", for: indexPath) as! HomeLaptopTableViewCell
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
