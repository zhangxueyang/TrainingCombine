//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/// .collect(.byTime(DispatchQueue.main, .seconds(4)))
/// 定时收集发送数据，收集到的数据合并到一起发送，只发送一次
testSample(label: "19_collcecTimeValue01") {
    let sourcePublisher = PassthroughSubject<Date, Never>()
    
    sourcePublisher
        .sink { completion in
            print("sourcePublisher: \(completion)")
        } receiveValue: { value in
            print("sourcePublisher receiveValue: \(value)")
        }.store(in: &subscriptions)

    // 每隔一段时间收集一次数据  跟 01_collect 一致
    sourcePublisher
        .collect(.byTime(DispatchQueue.main, .seconds(4)))
        .sink { completion in
            print("collect Publisher: \(completion)")
        } receiveValue: { value in
            print("collectPublisher receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .subscribe(sourcePublisher)
        .store(in: &subscriptions)
    
//    sourcePublisher receiveValue: 2024-12-16 07:26:06 +0000
//    sourcePublisher receiveValue: 2024-12-16 07:26:07 +0000
//    sourcePublisher receiveValue: 2024-12-16 07:26:08 +0000
//    sourcePublisher receiveValue: 2024-12-16 07:26:09 +0000
    
//    collectPublisher receiveValue: [2024-12-16 07:26:06 +0000, 2024-12-16 07:26:07 +0000, 2024-12-16 07:26:08 +0000, 2024-12-16 07:26:09 +0000]
    
}

