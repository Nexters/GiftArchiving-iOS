//
//  GiftModel.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/15.
//

import Foundation

struct GiftModel: Codable {
    let id, createdBy, content: String
    let isReceiveGift: Bool
    let name, receiveDate, createdAt: String
    let bgImgURL, noBgImgURL: String
    let category, emotion, reason: String

    enum CodingKeys: String, CodingKey {
        case id, createdBy, content, isReceiveGift, name, receiveDate, createdAt
        case bgImgURL = "bgImgUrl"
        case noBgImgURL = "noBgImgUrl"
        case category, emotion, reason
    }
}
