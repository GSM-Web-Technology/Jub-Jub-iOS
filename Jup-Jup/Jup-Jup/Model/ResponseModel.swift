//
//  ResponseModel.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/02/08.
//

import Foundation

struct ResponseModel: Codable {
    let code: Int
    let msg: String
    let success: Bool
}