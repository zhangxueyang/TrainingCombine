//
//  BaseResponse.swift
//  SwiftHelper
//
//  Created by zhangxueyang on 2024/11/6.
//

import Foundation
import SmartCodable

// 回调返回类型
//typealias DetailResponseHandler<T: SmartCodable> = (_ resp: T) -> Void
//typealias ListResponseHandler<T: SmartCodable> = (_ resp: ListResponse<T>) -> Void
//
//// 请求失败返回
//typealias NetRequestError = ((NetworkError) -> Void)?


// MARK: - 网络数据 Root 层
// RootResponse
struct RootResponse<T>: SmartCodable {
    var code : Int?
    
    var message:String?
    
    @SmartAny var data: T?
}

// MARK: - 服务器data 返回为空时使用、占位
struct EmptyResponse: SmartCodable {
    
}

