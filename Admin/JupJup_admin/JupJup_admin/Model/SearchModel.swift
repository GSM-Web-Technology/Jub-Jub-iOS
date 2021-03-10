//
//  SearchModel.swift
//  JupJup_admin
//
//  Created by 조주혁 on 2021/03/10.
//

import Foundation

struct SearchModel: Codable {
    let code: Int
    let msg: String
    let success: Bool
    let data: Data
    
}

struct Data: Codable {
    let content: String
    let count: Int
    let img_equipmentLocation: String
    let name: String
    let cellCount: Int = 1
}
