//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/// merge
testSample(label: "16_combineLatest01") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    publisher1
        .combineLatest(publisher2)
        .sink(receiveCompletion: { completion in
            print("16_combineLatest01 completion:\(completion)")
        }, receiveValue: { val1, val2 in
            print("16_combineLatest01 receive value ———— value1:\(val1) val2:\(val2)")
        }).store(in: &subscriptions)
    
    publisher1.send(12)
    publisher2.send("a")
    publisher1.send(300) // 可以和 a 组合输出 也可以和 b 组合输出
    publisher2.send("b")
    publisher2.send("c") // 可以和300 组合输出 也可以和400组合输出
    publisher1.send(400)

    // 合并两个Publisher   收到 publisher1 和 publisher2 后输出 12 a
    
//    Begin Test Name：16_combineLatest01
//    16_combineLatest01 receive value ———— value1:12 val2:a
//    16_combineLatest01 receive value ———— value1:300 val2:a
//    16_combineLatest01 receive value ———— value1:300 val2:b
//    16_combineLatest01 receive value ———— value1:300 val2:c
//    16_combineLatest01 receive value ———— value1:400 val2:c
//    End  Test Name：16_combineLatest01
    publisher1.send(completion: .finished)
}
