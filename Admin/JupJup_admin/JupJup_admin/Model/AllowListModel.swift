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
    let equipmentEnum: String
    let equipment: AllowListEquipment
    let admin: AllowListAdmin
    let eqa_Idx: Int
}

struct AllowListEquipment: Codable {
    let name: String
    let content: String
    let img_equipment: String
}

struct AllowListAdmin: Codable {
    let email: String
    let classNumber: String
    let name: String
}
