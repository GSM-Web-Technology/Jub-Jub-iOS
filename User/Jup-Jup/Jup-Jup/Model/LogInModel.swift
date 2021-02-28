//
//  LogInModel.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/02/04.
//

import Foundation

struct LogInModel: Codable {
    let success: Bool
    let code: Int
    let msg: String
    let data: Token
}

struct Token: Codable {
    let accessToken: String
}
