//
//  MyListModel.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/02/19.
//

import Foundation

struct MyListModel: Codable {
    let list: [MyList]
    let code: Int
}

struct MyList: Codable {
    let amount: Int
    let equipmentEnum: String
    let isReturn: Bool
    let equipment: Equipment
}

struct Equipment: Codable {
    let name: String
    let content: String
    let img_equipment: String
}
