//
//  NoticeData.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/19.
//

import Foundation

struct NoticeData: Codable {
    let noticeList: [NoticeList]
}

struct NoticeList: Codable {
    let title, content, createdAt: String
}
