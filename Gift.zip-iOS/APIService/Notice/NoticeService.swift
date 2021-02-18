//
//  NoticeService.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/19.
//

import Foundation
import Alamofire

struct NoticeService{
    
    static let shared = NoticeService()
    
    func getNotice(completion : @escaping (NetworkResult<Any>) -> (Void) ){
        let url = APIConstants.adminURL
        
        let header : HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        
        let dataRequest = AF.request(url,
                                     method: .get,
                                     headers: header)
        
        
        dataRequest.responseData{ response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else{
                    return
                }
                guard let data = response.value else{
                    return
                }
                completion(judge(status: statusCode, data: data))

            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
            
        }
        
        
        
    }
    
    private func judge(status : Int, data : Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(NoticeData.self, from : data) else{
            return .pathErr
        }
        
        switch status{
        case 200..<300:
            return .success(decodedData.noticeList)
        case 400..<500 :
            return .requestErr(decodedData)
        case 500 :
            return .serverErr
            
        default :
            return .networkFail
            
            
        }
        
        
    }
    
    
    
}
