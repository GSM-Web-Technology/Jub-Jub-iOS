//
//  NoticeModel.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/03/07.
//

import Foundation

struct NoticeModel: Codable {
    let success: Bool
    let list: [NoticeList]
}

struct NoticeList: Codable {
    let title: String
    let content: String
}
