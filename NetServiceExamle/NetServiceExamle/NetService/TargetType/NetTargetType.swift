//
//  NetTargetType.swift
//  SwiftHelper
//
//  Created by zhangxueyang on 2024/11/4.
//

import Foundation
import Moya

// MARK: - RequestHeader
protocol BaseURL: Moya.TargetType {}
extension BaseURL {
    var baseURL: URL {
        if let baseurl = URL(string: NetService.shared.config.baseUrl) {
            return baseurl
        }
        return URL(string: "https://doaminError")!
    }
}

// MARK: - RequestHeader
protocol RequestHeader: Moya.TargetType {}
extension RequestHeader {
    var headers: [String: String]? { nil }
}

// MARK: - GetMethod
public protocol GetMethod: TargetType {}
public extension GetMethod {
    var method: Moya.Method { .get }
}

// MARK: - PostMethod
public protocol PostMethod: TargetType {}
public extension PostMethod {
    var method: Moya.Method { .post }
}

/// 根据后台返回的状态码 确定是否请求成功
extension TargetType {
    func isSuccess(code: String) -> Bool {
        NetService.shared.config.successCodes.contains(code)
    }
    
}

