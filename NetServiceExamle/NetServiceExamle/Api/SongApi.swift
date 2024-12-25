//
//  SongApi.swift
//  NetServiceExamle
//
//  Created by zhangxueyang on 2024/12/25.
//

import Moya

// 接口说明
// https://www.free-api.com/doc/643
// https://api.cenguigui.cn/api/music/qianqian_music.php?msg=%E5%BC%A0%E6%9D%B0
//https://api.cenguigui.cn/api/music/qianqian_music.php?msg=%E5%BC%A0%E6%9D%B0&n=1

enum SongApi: TargetType {
    case lists(singer: String)
    case songDetail(singer: String, n: Int)
}

extension SongApi: BaseURL, GetMethod, RequestHeader, Interecptor  {
    var path: String {
        switch self {
        case .lists(_):
            return ""
        case .songDetail(_,_):
            return ""
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .lists(let singer):
            return .requestParameters(parameters: ["msg": singer], encoding: URLEncoding.queryString)
        case .songDetail(let singer, let n):
            return .requestParameters(parameters: ["msg":singer, "n":n], encoding: URLEncoding.queryString)
        }
    }
}
