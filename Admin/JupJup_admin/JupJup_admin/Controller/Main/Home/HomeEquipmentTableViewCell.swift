//
//  HomeEquipmentTableViewCell.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/02/21.
//

import UIKit

class HomeEquipmentTableViewCell: UITableViewCell {

    @IBOutlet weak var equipmentImage: UIImageView!
    @IBOutlet weak var equipmentName: UILabel!
    @IBOutlet weak var equipmentContent: UILabel!
    @IBOutlet weak var equipmentCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
