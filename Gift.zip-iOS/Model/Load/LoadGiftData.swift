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
    var name: String
    var content: String
    var receiveDate: String
    let bgColor: String
    let isReceiveGift: Bool
    let category: String
    let emotion: String
    let reason: String
    let frameType: String
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(String.self, forKey: .id)) ?? ""
        imgUrl = (try? values.decode(String.self, forKey: .imgUrl)) ?? ""
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        content = (try? values.decode(String.self, forKey: .content)) ?? ""
        receiveDate = (try? values.decode(String.self, forKey: .receiveDate)) ?? ""
        bgColor = (try? values.decode(String.self, forKey: .bgColor)) ?? "charcoalGrey"
        isReceiveGift = (try? values.decode(Bool.self, forKey: .isReceiveGift)) ?? true
        category = (try? values.decode(String.self, forKey: .category)) ?? ""
        emotion = (try? values.decode(String.self, forKey: .emotion)) ?? ""
        reason = (try? values.decode(String.self, forKey: .reason)) ?? ""
        frameType = (try? values.decode(String.self, forKey: .frameType)) ?? "SQUARE"
    }
}

