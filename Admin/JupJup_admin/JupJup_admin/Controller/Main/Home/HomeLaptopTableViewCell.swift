//
//  HomeLaptopTableViewCell.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/02/21.
//

import UIKit

class HomeLaptopTableViewCell: UITableViewCell {

    @IBOutlet weak var laptopImage: UIImageView!
    @IBOutlet weak var laptopName: UILabel!
    @IBOutlet weak var laptopBrand: UILabel!
    @IBOutlet weak var laptopSerialNumber: UILabel!
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
