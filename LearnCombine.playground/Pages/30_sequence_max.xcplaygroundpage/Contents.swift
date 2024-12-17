//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// min 获取stream 中最小 或者自定义
testSample(label: "30_max01") {
    let sourcepublisher = [100, 30, 45, 12, 1].publisher
    
    sourcepublisher
        .max()
        .sink { completion in
            print("30_max01: \(completion)")
        } receiveValue: { value in
            print("30_max01 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
}

testSample(label: "30_max02") {
    let sourcepublisher = PassthroughSubject<Int, Never>()
    
    sourcepublisher
        .max()
        .sink { completion in
            print("30_max02: \(completion)")
        } receiveValue: { value in
            print("30_max02 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    sourcepublisher.send(12)
    sourcepublisher.send(123)
    sourcepublisher.send(0)
    sourcepublisher.send(300)
    // 必须发送 completion 才能结束
    sourcepublisher.send(completion: .finished)
}

// 可以使用自定义对象 需要实现 Comparable 协议
testSample(label: "30_max03") {
    let sourcepublisher = PassthroughSubject<Int, Never>()
    
    sourcepublisher
        .max(by: { val1, val2 in
            return val1 < val2
        })
        .sink { completion in
            print("30_max03: \(completion)")
        } receiveValue: { value in
            print("30_max03 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    sourcepublisher.send(12)
    sourcepublisher.send(123)
    sourcepublisher.send(0)
    sourcepublisher.send(300)
    // 必须发送 completion 才能结束
    sourcepublisher.send(completion: .finished)
}

