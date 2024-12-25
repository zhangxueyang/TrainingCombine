//
//  InterceptorPlugin.swift
//  SwiftHelper
//
//  Created by zhangxueyang on 2024/11/4.
//

import Foundation
import Moya

// 发送过程传输到外部
struct InterceptorPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? MultiTarget else {return request}
        let apiTarget = target.target
        guard let apiTarget = apiTarget as? (any PluginType) else {
            return request
        }
        return apiTarget.prepare(request, target: target)
    }
    func willSend(_ request: RequestType, target: TargetType) {
        guard let target = target as? MultiTarget else {return }
        let apiTarget = target.target
        guard let apiTarget = apiTarget as? (any PluginType) else {
            return
        }
        return apiTarget.willSend(request, target: target)
    }
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        guard let target = target as? MultiTarget else {return }
        let apiTarget = target.target
        guard let apiTarget = apiTarget as? (any PluginType) else {
            return
        }
        return apiTarget.didReceive(result, target: target)
    }
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        guard let target = target as? MultiTarget else {return result}
        let apiTarget = target.target
        guard let apiTarget = apiTarget as? (any PluginType) else {
            return result
        }
        return apiTarget.process(result, target: target)
    }
}
