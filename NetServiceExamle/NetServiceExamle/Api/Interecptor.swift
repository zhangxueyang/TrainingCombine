//
//  SongApi.swift
//  NetServiceExamle
//
//  Created by zhangxueyang on 2024/12/25.
//

import Foundation
import Moya

protocol Interecptor: PluginType {
    
}
extension Interecptor {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        //添加token
        var request = request
        // 可以统一在此添加请求头参数
        // request.addValue("", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        
    }
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result{
        case .success(let  res):
            do {
                guard let dic = try res.mapJSON() as? [String : Any] else {return}
                guard let code = dic["code"] as? String else {return}
//                if code == .invalidTokenCode {
//                    //token 失效，更新token
//                }
            } catch  {
                
            }
        case .failure(_):
            break
        }
    }
}
