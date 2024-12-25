//
//  NetService+Combine.swift
//  SwiftHelper
//
//  Created by zhangxueyang on 2024/12/24.
//

import Moya
import SmartCodable
import Combine

// Combine
extension NetService {
    /**
    {
    "code": 200,
    "msg": "当前歌曲为免费歌曲,已获取完整音频",
    "data": {
        "title": "天空有雨 伞下有你（第十一届国际艾滋病反歧视午餐日主题曲）",
        "singer": "张杰",
     }
    }
    */
    static func requestPublisher<T: SmartCodable>(target: TargetType, dataType: T.Type) -> AnyPublisher<T, NetworkError> {
        return NetService.shared.multiProvider
            .requestPublisher(MultiTarget(target))
            .tryMap { response in
                try validateResponse(response)
            }
            .tryMap { data in
                try parseDetailtResponse(data, to: T.self)
            }
            .mapError { error in
                NetworkError.handleError(error)
            }
            .eraseToAnyPublisher()
    }
    
    /**
    {
    "code": 200,
    "msg": "当前歌曲为免费歌曲,已获取完整音频",
     "data":{
         "size" : 0,
         "pages" : 0,
         "data": [{
             "title": "天空有雨 伞下有你（第十一届国际艾滋病反歧视午餐日主题曲）",
             "singer": "张杰",
          }]
     }
    }
    */
    // 请求分页数据接口 根据服务器具体返回数据结构再做调整
    static func requestPageListsPublisher<T: SmartCodable>(target: TargetType, _ dataType: T.Type) -> AnyPublisher<ListResponse<T>, NetworkError> {
        return NetService.shared.multiProvider
            .requestPublisher(MultiTarget(target))
            .tryMap { response in
                try validateResponse(response)
            }
            .tryMap { data in
                try parseListResponse(data, to: T.self)
            }
            .mapError({ error in
                return NetworkError.handleError(error)
            }).eraseToAnyPublisher()
    }
    
}


extension NetService {
    /// 校验 HTTP 响应
    fileprivate static func validateResponse(_ response: Response) throws -> Data {
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.serverError(code: response.statusCode, message: "Server Error")
        }
        return response.data
    }
    
    /// 解析并处理业务逻辑错误
    fileprivate static func parseDetailtResponse<T: SmartCodable>(_ data: Data, to type: T.Type) throws -> T {
        guard let rootResponse = RootResponse<T>.deserialize(from: data) else {
            throw NetworkError.parsingError
        }
        
        if let code = rootResponse.code,
           !NetService.shared.config.successCodes.contains("\(code)") {
            throw NetworkError.businessError(code: code, message: rootResponse.message ?? "Unknown Error")
        }
        
        return rootResponse.data ?? T()
    }
    
    /// 解析并处理列表业务逻辑错误
    fileprivate static func parseListResponse<T: SmartCodable>(_ data: Data, to type: T.Type) throws -> ListResponse<T> {
        guard
            let rootInfo = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let rootResponse = RootResponse<ListResponse<T>>.deserialize(from: rootInfo)
        else {
            throw NetworkError.parsingError
        }
        
        if let code = rootResponse.code,
           !NetService.shared.config.successCodes.contains("\(code)") {
            throw NetworkError.businessError(code: code, message: rootResponse.message ?? "Unknown Error")
        }
        
        return rootResponse.data ?? ListResponse<T>()
    }
    
}
