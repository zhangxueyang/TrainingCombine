//
//  DetailResponse.swift
//  SwiftHelper
//
//  Created by zhangxueyang on 2024/11/6.
//

import Foundation
import SmartCodable

struct DetailResponse<T: SmartCodable>: SmartCodable {
    // 真实数据
    @SmartAny
    var data: T?
    
}
