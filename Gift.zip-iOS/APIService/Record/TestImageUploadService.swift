//
//  TestImageUploadService.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/11.
//

import Foundation
import Alamofire

struct TestImageUploadService{
    static let shared = TestImageUploadService()
    
    func signUp(
        bgImg: UIImage,
        completion : @escaping (NetworkResult<Any>) -> (Void)) {
        let url = "http://ec2-3-34-177-12.ap-northeast-2.compute.amazonaws.com:10000/api/gift/testImg"
        
        let header : HTTPHeaders = [
            "Content-Type":"multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multiPartFormData in
            
            let bgImgData = bgImg.jpegData(compressionQuality: 1.0)!
            multiPartFormData.append(bgImgData, withName: "img", fileName:"test.jpeg",mimeType:"image/jpeg")
        },
        to: url,
        usingThreshold: UInt64.init(),
        method:.post,
        headers: header)
        .validate(statusCode: 200..<500)
        .responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let value = response.value else { return }
                
                let networkResult = self.judge(status: statusCode, data: value)
                
                print(url)
                print(response)
                print("SUCCESS")
                completion(networkResult)
            case .failure(let err):
                print(err.localizedDescription)
                print("FAIL")
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
            print("called1")
            return .success(decodedData)
        case 400..<500 :
            print("called2")
            return .requestErr(decodedData)
        case 500 :
            print("called3")
            return .serverErr
            
        default :
            print("called4")
            return .networkFail
        }
    }
}



//        TestImageUploadService.shared.signUp(bgImg: renderImage) { (networkResult) -> (Void) in
//            switch networkResult {
//            case .success(let data):
//                if let bgData = data as? RecordGiftData {
//                    print(bgData.id)
//                }
//
//            case .requestErr(let msg):
//                print("requestErr")
//            case .pathErr :
//                print("pathErr")
//            case .serverErr :
//                print("serverERr")
//            case .networkFail :
//                print("networkFail")
//            default :
//                print("머지?")
//            }
//
//        }
