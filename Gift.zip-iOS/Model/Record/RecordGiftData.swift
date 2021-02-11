//
//  RecordGiftData.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/11.
//

import Foundation

struct RecordGiftData: Codable {
    let noBgImg: String
    let bgImg: String
    let id: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        noBgImg = (try? values.decode(String.self, forKey: .noBgImg)) ?? ""
        bgImg = (try? values.decode(String.self, forKey: .bgImg)) ?? ""
        id = (try? values.decode(String.self, forKey: .id)) ?? ""
    }
}
