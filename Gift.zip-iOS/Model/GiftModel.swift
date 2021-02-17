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
    let bgImgURL, noBgImgURL, frameType, bgColor: String
    let category, emotion, reason: String
    
    enum CodingKeys: String, CodingKey {
        case id, createdBy, content, isReceiveGift, name, receiveDate, createdAt
        case bgImgURL = "bgImgUrl"
        case noBgImgURL = "noBgImgUrl"
        case category, emotion, reason
        case frameType, bgColor
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(String.self, forKey: .id)) ?? ""
        createdBy = (try? values.decode(String.self, forKey: .createdBy)) ?? ""
        content = (try? values.decode(String.self, forKey: .content)) ?? ""
        isReceiveGift = (try? values.decode(Bool.self, forKey: .isReceiveGift)) ?? true
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        receiveDate = (try? values.decode(String.self, forKey: .receiveDate)) ?? ""
        createdAt = (try? values.decode(String.self, forKey: .createdAt)) ?? ""
        bgImgURL = (try? values.decode(String.self, forKey: .bgImgURL)) ?? ""
        noBgImgURL = (try? values.decode(String.self, forKey: .noBgImgURL)) ?? ""
        category = (try? values.decode(String.self, forKey: .category)) ?? "iconCategoryDefault"
        emotion = (try? values.decode(String.self, forKey: .emotion)) ?? "iconFeelingDefault"
        reason = (try? values.decode(String.self, forKey: .reason)) ?? "iconPurposeDefault"
        frameType = (try? values.decode(String.self, forKey: .frameType)) ?? ""
        bgColor = (try? values.decode(String.self, forKey: .bgColor)) ?? ""
        
    }
}
