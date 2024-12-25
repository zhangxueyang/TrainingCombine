//
//  NetWorkError.swift
//  SwiftHelper
//
//  Created by zhangxueyang on 2024/12/24.
//

import Moya
import Foundation

// MARK: - NetError
public enum NetworkError: Error {
    static var BussinessErrorCode: Int = -9999
    static var CommonErrorCode: Int = -10000
    
    case noInternetConnection // 没有网络连接
    case businessError(code: Int, message: String) // 业务逻辑错误，提示用户
    case serverError(code: Int, message: String) // 服务器错误，直接提示 网络错误，请稍后重试之类的
    case parsingError // 解析错误
    case unknownError // 网络未知错误
    
    var localizedDescription: String {
        switch self {
        case .noInternetConnection:
            return "No internet connection."
        case .businessError(_, let message):
            return message
        case .serverError(_, _):
            return "Net Error, Please try again"
        case .parsingError:
            return "Failed to parse data."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
    
    var code: Int {
        switch self {
        case .noInternetConnection, .parsingError, .unknownError:
            return NetworkError.CommonErrorCode
        case .businessError(_, _):
            return NetworkError.BussinessErrorCode
        case .serverError(let code, _):
            return code
        }
    }
    
    // 错误处理
    static func handleError(_ error: Error) -> NetworkError {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .underlying(let nsError as NSError, _): // 网络连接错误
                if nsError.domain == NSURLErrorDomain {
                    if nsError.code == NSURLErrorNotConnectedToInternet {
                        return .noInternetConnection
                    }
                }
                
            case .statusCode(let response): // 服务器错误
                let message = "Server error: \(response.statusCode)"
                return .serverError(code: response.statusCode, message: message)
                
            case .objectMapping, .jsonMapping, .stringMapping:
                return .parsingError
                
            default:
                break
            }
        }
        
        if let netError = error as? NetworkError {
            switch netError {
            case .businessError(let code, let message):
                if code == 10000 || code == 30 { // 服务器返回的特殊错误码
                    return .businessError(code: code, message: message)
                }
                return netError
            default:
                break
            }
            return netError
        }
        
        return .unknownError
    }
    
}
