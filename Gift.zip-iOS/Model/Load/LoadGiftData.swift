//
//  LoadGiftData.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/13.
//

import Foundation
struct LoadGiftData: Codable {
    let id: String
    let imgUrl: String
    let name: String
    let content: String
    let receiveDate: String
    let bgColor: String
    let isReceiveGift: Bool
    let category: String
    let emotion: String
    let reason: String
    let frameType: String
}

