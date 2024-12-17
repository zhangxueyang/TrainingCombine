//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

testSample(label: "33_output01") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    
    sourcePublisher
        .output(at: 2)
        .sink { completion in
            print("33_output01: \(completion)")
        } receiveValue: { value in
            print("33_output01 receiveValue: \(value)")
        }.store(in: &subscriptions)
        
    sourcePublisher.send("第0个")
    sourcePublisher.send("第1个")
    sourcePublisher.send("第2个")
    sourcePublisher.send("第3个")
    
    sourcePublisher.send(completion: .finished)
}

// 输出下标范围
testSample(label: "33_output02") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    
    sourcePublisher
        .output(in: 0...2)
        .sink { completion in
            print("33_output02: \(completion)")
        } receiveValue: { value in
            print("33_output02 receiveValue: \(value)")
        }.store(in: &subscriptions)
        
    sourcePublisher.send("第0个")
    sourcePublisher.send("第1个")
    sourcePublisher.send("第2个")
    sourcePublisher.send("第3个")
    
    sourcePublisher.send(completion: .finished)
}
