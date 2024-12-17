//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// min 获取stream 中最小 或者自定义
testSample(label: "29_min01") {
    let sourcepublisher = [100, 30, 45, 12, 1].publisher
    
    sourcepublisher
        .min()
        .sink { completion in
            print("29_min01: \(completion)")
        } receiveValue: { value in
            print("29_min01 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
}

testSample(label: "29_min02") {
    let sourcepublisher = PassthroughSubject<Int, Never>()
    
    sourcepublisher
        .min()
        .sink { completion in
            print("29_min02: \(completion)")
        } receiveValue: { value in
            print("29_min02 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    sourcepublisher.send(12)
    sourcepublisher.send(123)
    sourcepublisher.send(0)
    sourcepublisher.send(300)
    // 必须发送 completion 才能结束
    sourcepublisher.send(completion: .finished)
}

testSample(label: "29_min03") {
    let sourcepublisher = PassthroughSubject<Int, Never>()
    
    sourcepublisher
        .min(by: { val1, val2 in
            return val1 < val2
        })
        .sink { completion in
            print("29_min03: \(completion)")
        } receiveValue: { value in
            print("29_min03 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    sourcepublisher.send(12)
    sourcepublisher.send(123)
    sourcepublisher.send(0)
    sourcepublisher.send(300)
    // 必须发送 completion 才能结束
    sourcepublisher.send(completion: .finished)
}
