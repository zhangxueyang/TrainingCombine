//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/// 05_scan01, 合并
/// scan(0) { newVal , currVal in
/// 其中参数为初始值，newVal 为上次的 “积累”计算的值，currVal 为当前发布的值。
/// 和reduce不同的是，scan每次计算的 的结果都会被 订阅者接收到。而reduce 只有最后的结果。
testSample(label: "05_scan01") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    sourcePublisher
        .scan(0) { newVal, currValue in
            print("newVal: \(newVal) sumValue: \(currValue)")
            return newVal + currValue
        }
        .sink(receiveCompletion: { completion in
            print("05_scan completion:\(completion)")
        }, receiveValue: { val1  in
            print("05_scan val1 : \(val1) ")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2)
    sourcePublisher.send(3)
    sourcePublisher.send(4)
    
    sourcePublisher.send(completion: .finished)
}

testSample(label: "05_scan02") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    sourcePublisher
        .reduce(0, { newVal, currValue in
            print("newVal: \(newVal) sumValue: \(currValue)")
            return newVal + currValue
        })
        .sink(receiveCompletion: { completion in
            print("05_scan completion:\(completion)")
        }, receiveValue: { val1  in
            print("05_scan val1 : \(val1) ")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(1)
    sourcePublisher.send(2)
    sourcePublisher.send(3)
    sourcePublisher.send(4)
    
    sourcePublisher.send(completion: .finished)
}
