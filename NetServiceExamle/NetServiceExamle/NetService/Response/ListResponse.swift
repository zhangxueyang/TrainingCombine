//
//  ListResponse.swift
//  SwiftHelper
//
//  Created by zhangxueyang on 2024/11/6.
//

import Foundation
import SmartCodable

// 分页逻辑处理 根据服务器返回类型处理
struct ListResponse<T: SmartCodable>: SmartCodable {
    
    var data: [T]?
    
    /// 有多少条
    var total:Int!

    /// 有多少页
    var pages:Int!

    /// 当前每页显示多少条
    var size:Int!

    /// 当前页
    var page:Int!

    /// 下一页
    var next:Int?

    /// 获取下一页
    static func nextPage(_ data: ListResponse?) -> Int {
        if let meta = data,let next = meta.next {
            return next
        }
        
        return 1
    }
}
