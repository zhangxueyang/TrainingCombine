//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

testSample(label: "01_Collect01") {
    let arrPublisher = [100,200,300,20,14].publisher
    arrPublisher
        .collect()
        .sink(receiveCompletion: { completion in
            print("01_Collect completion:\(completion)")
        }, receiveValue: { value in
            print("01_Collect value : \(value)")
        }).store(in: &subscriptions)
}

/// collect, 获取指定的 元素个数。
testSample(label: "01_Collect02") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    sourcePublisher
        //.print("collectPublisher")
        .collect(3)
        .sink(receiveCompletion: { completion in
            print("01_Collect02 completion:\(completion)")
        }, receiveValue: { value in
            print("01_Collect02 value : \(value)")
        }).store(in: &subscriptions)
    
    sourcePublisher.send(55)
    sourcePublisher.send(200)
    sourcePublisher.send(300)
    
    sourcePublisher.send(400)
    sourcePublisher.send(500)
    sourcePublisher.send(600)
    
    // 只有达到三个订阅才会执行接下来的操作，或者发送执行完毕，才会把未达到目标的消息发送出去.否则直到取消也不会再出发订阅
    sourcePublisher.send(700)
    sourcePublisher.send(800)
//    sourcePublisher.send(900)

    sourcePublisher.send(completion: .finished)
}


testSample(label: "01_Collect03") {
    /// https://hit-alibaba.github.io/interview/iOS/ObjC-Basic/Runloop.html
    /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html
    /// https://newbedev.com/runloop-vs-dispatchqueue-as-scheduler

    Timer.publish(every: 1, on: RunLoop.main, in: .common)
        .autoconnect()
        .collect(.byTime(RunLoop.main, .seconds(5)))
        .sink {
            print("\($0)", terminator: "\n")
        }.store(in: &subscriptions)
    
    
}
