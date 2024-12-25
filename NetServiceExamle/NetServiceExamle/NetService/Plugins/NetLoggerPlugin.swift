//
//  NetLoggerPlugin.swift
//  SwiftHelper
//
//  Created by zhangxueyang on 2024/11/4.
//

import Foundation
import Moya

struct NetLoggerPlugin {
    static func loggerPlugn() -> NetworkLoggerPlugin {
        NetworkLoggerPlugin.init(configuration: .init(formatter: .init(requestData: { (data: Data) in
            return prettyString(data: data)
        }, responseData: { (data: Data) in
            return prettyString(data: data)
        }), logOptions: .verbose))
    }
}

extension NetLoggerPlugin {
    fileprivate static func prettyString(data: Data) -> String {
        if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString.replacingOccurrences(of: "\\", with: "")
        }
        return String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "") ?? ""
    }
}

