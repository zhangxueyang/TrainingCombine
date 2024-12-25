//
//  Song.swift
//  NetServiceExamle
//
//  Created by zhangxueyang on 2024/12/25.
//

import SmartCodable

struct SongLists: SmartCodable {
    var title: String = ""
    var singer: String = ""
    var vip: String = ""

    var n: Int = 0
    
}

struct Song: SmartCodable {
    var title: String = ""
    var singer: String = ""
    var lyric: String = ""
    
    var cover: String = ""
    var link: String = ""
    var musicUrl: String = ""
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [
            CodingKeys.musicUrl <--- "music_url"
        ]
    }
}
