//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// compactMap 会将所有 nil 值过滤掉，只传递非 nil 的值。这部分工作是正确的
testSample(label: "08_compactMap01") {
    let publisher = (0...5).publisher
    let numberInfo = [1: "一", 2: "二", 3:"三", 4:nil, 5:"五"]
    
    publisher
        .compactMap{ numberInfo[$0] } // 过滤 nil 并解包非 nil 值
//    再次解包过滤 nil 值
//        .compactMap{ $0 }
        .sink {
            print("08_compactMap01 recive value \(String(describing: $0))")
//            numberInfo 包含:"4:nil"，元素时，打印以下结果
//            Optional("一")
//            Optional("二")
//            Optional("三")
//            nil
//            Optional("五")
            
            // 不包含:"4:nil"
//            一
//            二
//            三
//            五
        }
//        .sink { completion in
//            print("08_compactMap01 completion:\(completion)")
//        } receiveValue: { value in
//            print("08_compactMap01 recive value \(String(describing: value))")
//        }
        .store(in: &subscriptions)
}

testSample(label: "08_compactMap02") {
    let publisher = ["1", "2", "3", "4", "a", "5"]

    publisher
        .compactMap { Float($0) }
        .publisher.sink { completion in
            print("08_compactMap02 completion:\(completion)")
        } receiveValue: { value in
            print("08_compactMap02 recive value \(String(describing: value))")
        }.store(in: &subscriptions)

}


