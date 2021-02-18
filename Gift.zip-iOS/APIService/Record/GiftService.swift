//
//  RecordGiftService.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/11.
//

import Foundation
import Alamofire

struct GiftService {
    static let shared = GiftService()
    
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
                    frameType: String,
                    completion : @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.baseURL + APIConstants.recordGiftURL
        

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
            "frameType": frameType
        ]
        
        AF.upload(multipartFormData: { multiPartFormData in
            for (key,value) in body {
                if value is String{
                    let val = value as! String
                    multiPartFormData.append(val.data(using:String.Encoding.utf8)!,withName:key)
//                    print(key)
                } else if value is Bool {
                    let val = value as! Bool
                    multiPartFormData.append("\(val)".data(using:String.Encoding.utf8)!, withName: key)
//                    print(key)
                } else if value is Int{
                    let val = value as! Int
                    multiPartFormData.append("\(val)".data(using:String.Encoding.utf8)!, withName: key)
//                    print(key)
                }
            }
            let bgImgData = bgImg.pngData()!
            multiPartFormData.append(bgImgData, withName: "bgImg", fileName:"test1.png",mimeType:"image/png")
            
            let noBgImgData = noBgImg.pngData()!
            multiPartFormData.append(noBgImgData, withName: "noBgImg", fileName: "test2.png", mimeType: "image/png")
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
                completion(networkResult)
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
            }
        }
    }
    
    func deleteGift(giftId: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        let url = APIConstants.baseURL + APIConstants.deleteGiftURL + "/\(giftId)"
        
        let dataRequest = AF.request(url,
                                      method: .delete,
                                      headers: header)
        
        
        dataRequest
            .validate(statusCode: 200..<500)
            .responseData { (response) in
                print(response.result)
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let value = response.value else { return }
                    
                    let networkResult = self.judge(status: statusCode, data: value)
                    completion(networkResult)
                case .failure(let err):
                    print(err.localizedDescription)
                    completion(.networkFail)
                }
            }
    }
    
    func getOneGift(id: String ,completion: @escaping (NetworkResult<Any>) -> Void) {
       
        let header: HTTPHeaders = ["Accept": "application/json"]
        
        let url = APIConstants.baseURL + APIConstants.getOneGiftURL + "/\(id)"
        let dataRequest = AF.request(url, method: .get, headers: header)
        
        dataRequest.validate(statusCode: 200..<500)
            .responseData { (response) in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let value = response.value else { return }
                    
                    let networkResult = self.judgeOneGift(status: statusCode, data: value)
                    
                    print(statusCode)
                    completion(networkResult)
                case .failure: completion(.networkFail)
                    
                }
                
            }
    }
//    {
//      "bgColor": "string",
//      "category": "LIVING",
//      "content": "string",
//      "emotion": "CHEER",
//      "name": "string",
//      "reason": "ANNIVERSARY",
//      "receiveDate": "2021-02-17T04:47:09.010Z"
//    }
    func putGift(category: String, content: String, emotion: String, reason: String, receiveDate: String, giftId: String ,completion: @escaping (NetworkResult<Any>) -> Void) {
       
        let header: HTTPHeaders = ["Accept": "application/json"]
        
        let url = APIConstants.baseURL + APIConstants.getOneGiftURL + "/\(giftId)"
        
        print(url)
        
        let body : Parameters = [
            "content" : content,
            "receiveDate": receiveDate,
            "category" : category,
            "emotion": emotion,
            "reason": reason,
        ]
        print(body)
        let dataRequest = AF.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.validate(statusCode: 200..<500)
            .responseData { (response) in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let value = response.value else { return }
                    
                    let networkResult = self.judgeOneGift(status: statusCode, data: value)
                    
                    print(statusCode)
                    completion(networkResult)
                case .failure: completion(.networkFail)
                    
                }
                
            }
    }
    
    

    
    func judgeOneGift(status : Int, data : Data) -> NetworkResult<Any> {
      
        switch status{
        case 200..<300:
            return getOneGift(data: data)
        case 400..<500 :
            return .requestErr("requestErr")
        case 500 :
            return .serverErr
        default :
            return .networkFail
        }
    }
    
    func getOneGift(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GiftModel.self, from : data) else {
            return .pathErr
        }
        
        return .success(decodedData)
    }
    
    func judge(status : Int, data : Data) -> NetworkResult<Any> {
      
        switch status{
        case 200..<300:
            return recordGift(data: data)
        case 400..<500 :
            return .requestErr("requestErr")
        case 500 :
            return .serverErr
        default :
            return .networkFail
        }
    }
    
    func recordGift(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(RecordGiftData.self, from : data) else {
            return .pathErr
        }
        
        return .success(decodedData)
    }
}

