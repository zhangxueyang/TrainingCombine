//
//  NetService.swift
//  SwiftHelper
//
//  Created by zhangxueyang on 2024/11/4.
//

import Foundation
import Moya
import SmartCodable
import Combine

// 为了后续封装成库 暂时如此设计
struct NetConfiger {
    let baseUrl: String
    let successCodes: [String]
    
    init(baseUrl: String, successCodes: [String]) {
        self.baseUrl = baseUrl
        self.successCodes = successCodes
    }
    
}

// MARK: - NetService
final class NetService {
    static let shared: NetService = NetService()
    // 禁止外部调用
    private init() {}
    
    var config: NetConfiger = NetConfiger(baseUrl: "", successCodes: ["200"])
    
    /// 需要在 Appdelegate 调用此方法 设置服务器 Root域名
    /// - Parameters:
    ///   - baseUrl: https://www.xxxx.com
    ///   - successCodes: ["0","200"] 服务器认为接口返回正常业务逻辑的状态码
    public static func config(baseUrl: String, successCodes: [String]) {
        shared.config = NetConfiger(baseUrl: baseUrl, successCodes: successCodes)
    }
    
    lazy var plugins: [PluginType] = [InterceptorPlugin(), NetLoggerPlugin.loggerPlugn()]
    lazy var multiProvider = MoyaProvider<MultiTarget>(plugins: plugins)
    
}

