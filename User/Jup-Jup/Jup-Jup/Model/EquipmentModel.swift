//
//  EquipmentModel.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/02/04.
//

import Foundation

struct EquipmentModel: Codable {
    let code: Int
    let list: [List]
    let msg: String
    let success: Bool
}

struct List: Codable {
    let content: String
    let count: Int
    let img_equipment: String
    let name: String
}

