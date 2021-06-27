//
//  EquipmentManager.swift
//  Jup-Jup
//
//  Created by 조주혁 on 2021/06/27.
//

import Foundation

class EquipmentManager {
    static var equipmentTitle: String?
    static var equipmentKind: String?
    static var equipmentImgURL: String?
    static var equipmentCount: Int?
    
    // 기자재 이름
    class func getEquipmentTitle() -> String {
        guard let title = equipmentTitle else { return "" }
        return title
    }
    
    class func saveEquipmentTitle(title: String) {
        equipmentTitle = title
    }
    
    class func removeEquipmentTitle() {
        equipmentTitle = nil
    }
    
    
    // 기자재 종류
    class func getEquipmentKind() -> String {
        guard let kind = equipmentKind else { return "" }
        return kind
    }
    
    class func saveEquipmentKind(kind: String) {
        equipmentKind = kind
    }
    
    class func removeEquipmentKind() {
        equipmentKind = nil
    }
    
    
    // 기자재 이미지 URL
    class func getEquipmentImgURL() -> String {
        guard let url = equipmentImgURL else { return "" }
        return url
    }
    
    class func saveEquipmentImgURL(imgURL: String) {
        equipmentImgURL = imgURL
    }
    
    class func removeEquipmentImgURL() {
        equipmentImgURL = nil
    }
    
    
    // 기자재 수량
    class func getEquipmentCount() -> Int {
        guard let count = equipmentCount else { return 0 }
        return count
    }
    
    class func saveEquipmentCount(count: Int) {
        equipmentCount = count
    }
    
    class func removeEquipmentCount() {
        equipmentCount = nil
    }
}
