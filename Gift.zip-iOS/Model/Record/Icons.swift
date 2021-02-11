//
//  Icons.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/11.
//

import Foundation

struct Icons {
    let index: Int
    let imageName: String
    let name: String
    let englishName: String
    
    static let category: [Icons] = [
        Icons(index: 0, imageName: "icDigital", name: "디지털", englishName: "DIGITAL"),
        Icons(index: 1, imageName: "icGroceries", name: "식품", englishName: "FOOD"),
        Icons(index: 2, imageName: "icLiving", name:  "리빙", englishName: "LIVING"),
        Icons(index: 3, imageName: "icPet", name: "펫", englishName: "PET"),
        Icons(index: 4, imageName: "icBaby", name: "유아동", englishName: "BABY"),
        Icons(index: 5, imageName: "icGiftCard", name: "상품권", englishName: "GIFT_CARD"),
        Icons(index: 6, imageName: "icSports", name: "스포츠", englishName: "SPORTS"),
        Icons(index: 7, imageName: "icFashion", name: "패션", englishName: "FASHION"),
        Icons(index: 8, imageName: "icCosmetic", name: "화장품", englishName: "BEAUTY"),
        Icons(index: 9, imageName: "icMcoupon", name: "모바일교환권", englishName: "VOUCHER"),
        Icons(index: 10, imageName: "icCulture", name: "컬처", englishName: "CULTURE"),
        Icons(index: 11, imageName: "icEtc", name: "기타", englishName: "ETC")
    ]
    
    static let purpose: [Icons] = [
        Icons(index: 0, imageName: "icBirthday", name: "생일", englishName: "BIRTHDAY"),
        Icons(index: 1, imageName: "icAnniversary", name: "기념일", englishName: "ANNIVERSARY"),
        Icons(index: 2, imageName: "icWedding", name:  "결혼", englishName: "MARRIAGE"),
        Icons(index: 3, imageName: "icGetajob", name: "취업", englishName: "EMPLOYMENT"),
        Icons(index: 4, imageName: "icHoliday", name: "명절", englishName: "HOLIDAY"),
        Icons(index: 5, imageName: "icGraduation", name: "졸업", englishName: "STUDY"),
        Icons(index: 6, imageName: "icApology", name: "사과", englishName: "APOLOGIZE"),
        Icons(index: 7, imageName: "icAppreciation", name: "감사", englishName: "THANKS"),
        Icons(index: 8, imageName: "icCheer", name: "응원", englishName: "CHEER_UP"),
        Icons(index: 9, imageName: "icHousewarming", name: "집들이", englishName: "HOUSES"),
        Icons(index: 10, imageName: "icJust", name: "그냥", englishName: "JUST"),
        Icons(index: 11, imageName: "icEtc", name: "기타", englishName: "ETC")
    ]
    
    static let emotionSend: [Icons] = [
        Icons(index: 0, imageName: "icEmojiCheer", name: "응원해", englishName: "GOOD"),
        Icons(index: 0, imageName: "icEmojiSorry", name: "미안해", englishName: "SORRY"),
        Icons(index: 0, imageName: "icEmojiBest", name: "나최고지", englishName: "BEST"),
        Icons(index: 0, imageName: "icEmojiCelebration", name: "축하해", englishName: "CELEBRATE"),
    ]
    static let emotionGet: [Icons] = [
        Icons(index: 0, imageName: "icEmojiSense", name: "센스최고", englishName: "GOOD"),
        Icons(index: 0, imageName: "icEmojiLove", name: "사랑해", englishName: "LOVE"),
        Icons(index: 0, imageName: "icEmojiTouch", name: "감동이야", englishName: "TOUCH"),
        Icons(index: 0, imageName: "icEmojiSurprisal", name: "놀라워", englishName: "SURPRISE"),
    ]
    
}

