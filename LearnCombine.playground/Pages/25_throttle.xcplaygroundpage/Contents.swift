//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

testSample(label: "25_throttle1") {
    let publisher = PassthroughSubject<String, Never>()
    
    let throttle = publisher
        // 指定时间内 发送第一个值，到达时间后 根据 latest参数决定是发送 第一个值 还是最后一个值
        .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
        .share()
    
    publisher.sink { completion in
        print("25_throttle1: \(completion)")
    } receiveValue: { value in
        print("25_throttle1 receiveValue: \(value)")
    }.store(in: &subscriptions)
    
    throttle
        .sink { completion in
            print("    throttle: \(completion)")
        } receiveValue: { value in
            print("    throttle receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    let input: [(Double, String)] = [
        (0.0, "y"), // throttle 发送第一个 不会再次发送
        (0.1, "yo"),
        (0.2, "you"),
        (0.9, "your"),
        (1.6, "your b"),// throttle 上一秒内发送最后一个 your
        (1.7, "your ba"),
        (1.8, "your bab"),
        (2.5, "your baby"),
    ]
    
    publisher.feed(with: input)

}
