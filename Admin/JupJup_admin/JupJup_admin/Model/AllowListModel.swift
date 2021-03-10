//
//  AllowListModel.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/03/10.
//

import Foundation

struct AllowListModel: Codable {
    let success: Bool
    let list: [AllowList]
}

struct AllowList: Codable {
    let amount: Int
    let reason: String
}
