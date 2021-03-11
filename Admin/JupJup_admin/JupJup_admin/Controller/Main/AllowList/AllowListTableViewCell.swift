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
    @IBOutlet weak var allowBtn: UIButton! {
        didSet {
            allowBtn.layer.borderWidth = 1
            allowBtn.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var rejectBtn: UIButton! {
        didSet {
            rejectBtn.layer.borderWidth = 1
            rejectBtn.layer.cornerRadius = 5
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
