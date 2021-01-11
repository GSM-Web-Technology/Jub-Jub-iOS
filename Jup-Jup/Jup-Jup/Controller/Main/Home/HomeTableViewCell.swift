//
//  HomeTableViewCell.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/01/08.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var homeTitleName: UILabel!
    @IBOutlet weak var homeSubName: UILabel!
    @IBOutlet weak var homeCount: UILabel!
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
