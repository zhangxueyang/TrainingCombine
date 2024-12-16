//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// measureInterval 统计两次发送的时间间隔
testSample(label: "28_measureInterval") {
    let publisher = PassthroughSubject<Int, Never>()
    
    let measure = publisher.measureInterval(using: DispatchQueue.main)
    
    publisher.sink { completion in
        print("28_measureInterval: \(completion)")
    } receiveValue: { value in
        print("28_measureInterval receiveValue: \(value)")
    }.store(in: &subscriptions)
    
    measure.sink { completion in
        print("    measure: \(completion)")
    } receiveValue: { value in
        print("    measure receiveValue: \(value)")
    }.store(in: &subscriptions)
    
    publisher.send(1)
    Thread.sleep(forTimeInterval: 0.4)
    publisher.send(2)
    Thread.sleep(forTimeInterval: 0.8)
    publisher.send(5)
    Thread.sleep(forTimeInterval: 1.0)
    publisher.send(8)
    
    publisher.send(completion: .finished)
}
