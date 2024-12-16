//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// .collect(.byTimeOrCount(DispatchQueue.main, .seconds(4), 2))
// 两个条件 满足一个就发送数据 数据不会重复
// 普遍用于收集日志  定时收集 以及收集达到一定数量后 处理

testSample(label: "21_collect_time1") {
    let sourcePublisher = PassthroughSubject<Date, Never>()
    
    sourcePublisher
        .sink { completion in
            print("sourcePublisher: \(completion)")
        } receiveValue: { value in
            print("sourcePublisher receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    sourcePublisher
        .collect(.byTimeOrCount(DispatchQueue.main, .seconds(4), 2))
        .flatMap { dates in
            dates.publisher
        }
        .sink { completion in
            print("    collect Publisher: \(completion)")
        } receiveValue: { date in
            print("    collect receiveValue: \(date)")
        }.store(in: &subscriptions)

    Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .subscribe(sourcePublisher)
        .store(in: &subscriptions)
}
