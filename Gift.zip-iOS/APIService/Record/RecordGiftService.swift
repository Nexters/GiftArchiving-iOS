//
//  RecordGiftService.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/11.
//

import Foundation
import Alamofire

struct RecordGiftService{
    static let shared = RecordGiftService()
    func recordGift(content : String,
                    isReceiveGift: Bool,
                    name: String,
                    receiveDate: String,
                    createdBy: String,
                    category : String,
                    emotion: String,
                    reason: String,
                    bgColor: String,
                    bgImg: UIImage,
                    noBgImg: UIImage,
                    completion : @escaping (NetworkResult<Any>) -> (Void)) {
        let url = "http://ec2-3-34-177-12.ap-northeast-2.compute.amazonaws.com:10000/api/gift/create"
        
        let header : HTTPHeaders = [
            "Content-Type":"multipart/form-data"
        ]
        
        let body : Parameters = [
            "content" : content,
            "isReceiveGift": isReceiveGift,
            "name": name,
            "receiveDate": receiveDate,
            "createdBy": createdBy,
            "category" : category,
            "emotion": emotion,
            "reason": reason,
            "bgColor": bgColor,
        ]
        
        AF.upload(multipartFormData: { multiPartFormData in
            for (key,value) in body {
                if value is String{
                    let val = value as! String
                    multiPartFormData.append(val.data(using:String.Encoding.utf8)!,withName:key)
                    print(key)
                } else if value is Bool {
                    let val = value as! Bool
                    multiPartFormData.append("\(val)".data(using:String.Encoding.utf8)!, withName: key)
                    print(key)
                } else if value is Int{
                    let val = value as! Int
                    multiPartFormData.append("\(val)".data(using:String.Encoding.utf8)!, withName: key)
                    print(key)
                }
            }
            let bgImgData = bgImg.jpegData(compressionQuality: 1.0)!
            multiPartFormData.append(bgImgData,withName: "bgImg", fileName:"test1.jpeg",mimeType:"image/jpeg")
            
            let noBgImgData = noBgImg.jpegData(compressionQuality: 1.0)!
            multiPartFormData.append(noBgImgData, withName: "noBgImg", fileName: "test2.jpeg", mimeType: "image/jpeg")
        },
        to: url,
        usingThreshold: UInt64.init(),
        method:.post,
        headers:header)
        .responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let value = response.value else { return }
                let networkResult = self.judge(status: statusCode, data: value)
                print(url)
                completion(networkResult)
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
            }
        }
    }
    
    func judge(status : Int, data : Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(RecordGiftData.self, from : data) else {
            return .pathErr
        }
        print("HELLO")
        print(decodedData)
        switch status{
        case 200..<300:
            return .success(decodedData)
        case 400..<500 :
            return .requestErr(decodedData)
        case 500 :
            return .serverErr
        default :
            return .networkFail
        }
    }
}

