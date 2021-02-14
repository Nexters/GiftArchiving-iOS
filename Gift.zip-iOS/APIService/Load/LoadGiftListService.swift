//
//  LoadGiftListService.swift
//  Gift.zip-iOS
//
//  Created by Choi jeong heon on 2021/02/13.
//

import Foundation
import Alamofire

struct LoadGiftListService{
    static let shared = LoadGiftListService()
    func getReceivedGifts(page : Int, size : Int, isReceiveGift: Bool, completion: @escaping([LoadGiftData]) -> ()) {
        let createdBy = "2"
        let url = APIConstants.baseURL + APIConstants.getGiftsURL + "/" + createdBy
        let params = ["createdBy" : createdBy, "page" : page, "size" : size , "isReceiveGift" : isReceiveGift] as [String : Any]
        AF.request(url, method: .get, parameters: params).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let res):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(LoadAPIResponse.self, from: jsonData)
                    completion(json.gifts)
                }catch(let err){
                    debugPrint(err.localizedDescription)
                    completion(Array<LoadGiftData>())
                }
            case .failure(let err):
                debugPrint(err.localizedDescription)
                completion(Array<LoadGiftData>())
            }
        })
    }
    func getId() -> String{
        let SPREF = UserDefaults.standard
        if let appleId = SPREF.string(forKey: "appleId"){
            
            return appleId
            
        }else{
            if let kakaoId = SPREF.string(forKey: "kakaoId"){
                return kakaoId
            }
        }
        return ""
    }
}
