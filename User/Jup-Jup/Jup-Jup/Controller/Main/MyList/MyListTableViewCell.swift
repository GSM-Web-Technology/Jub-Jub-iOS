//
//  MyListTableViewCell.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/08.
//

import UIKit

class MyListTableViewCell: UITableViewCell {

    @IBOutlet weak var myListImageView: UIImageView!
    @IBOutlet weak var myListTitleName: UILabel!
    @IBOutlet weak var myListSubName: UILabel!
    @IBOutlet weak var myListCount: UILabel!
    @IBOutlet weak var myListStatusLabel: UILabel! {
        didSet {
            myListStatusLabel.clipsToBounds = true
            myListStatusLabel.layer.cornerRadius = 10
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
