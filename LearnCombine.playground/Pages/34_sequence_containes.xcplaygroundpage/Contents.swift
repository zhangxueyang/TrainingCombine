//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

///contains 判断 发布数据是否出现在发布数据 一览中。
testSample(label: "34_Contains01") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    
    sourcePublisher
        .contains("second12") /// 参数遵循Equatable 协议,且 参数类型和 发布类型一致。
        .sink { completion in
            print("34_Contains01: \(completion)")
        } receiveValue: { value in
            // 接收的结果是Bool值
            print("34_Contains01 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    sourcePublisher.send("First11")
    sourcePublisher.send("second12")
    sourcePublisher.send("third13")

    sourcePublisher.send(completion: .finished)
}

///contains 判断 发布数据是否出现在发布数据 一览中。
testSample(label: "34_Contains01") {
    let sourcePublisher = PassthroughSubject<String, Never>()
    
    sourcePublisher
        .contains(where: { value in
            return value.contains("t") && value.contains("h") && value.contains("9")
        })
        .sink { completion in
            print("34_Contains01: \(completion)")
        } receiveValue: { value in
            print("34_Contains01 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    sourcePublisher.send("First11")
    sourcePublisher.send("second12")
    sourcePublisher.send("third13")

    sourcePublisher.send(completion: .finished)
}
