//
//  AllowListTableViewCell.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/03/10.
//

import UIKit

class AllowListTableViewCell: UITableViewCell {

    @IBOutlet weak var allowListImage: UIImageView!
    @IBOutlet weak var allowListName: UILabel!
    @IBOutlet weak var allowListContent: UILabel!
    @IBOutlet weak var allowListCount: UILabel!
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
