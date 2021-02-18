//
//  SearchModel.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/02/05.
//

import Foundation

struct Search: Codable {
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
