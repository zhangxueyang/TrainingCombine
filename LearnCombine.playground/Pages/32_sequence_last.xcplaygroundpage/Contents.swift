//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// min 获取stream 中最小 或者自定义
testSample(label: "32_last01") {
    let sourcepublisher = PassthroughSubject<String, Never>()
    
    sourcepublisher
        .last()
        .sink { completion in
            print("32_last01: \(completion)")
        } receiveValue: { value in
            print("32_last01 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    sourcepublisher.send("hello")
    sourcepublisher.send("world")
    sourcepublisher.send(completion: .finished)
}

testSample(label: "32_last02") {
    let sourcepublisher = PassthroughSubject<String, Never>()
    
    sourcepublisher
        .last(where: { "you are the third one".contains($0) })
        .sink { completion in
            print("32_last02: \(completion)")
        } receiveValue: { value in
            print("32_last02 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    sourcepublisher.send("hello")
    sourcepublisher.send("world")
    sourcepublisher.send("third")
    sourcepublisher.send("one")
    sourcepublisher.send(completion: .finished)
}
