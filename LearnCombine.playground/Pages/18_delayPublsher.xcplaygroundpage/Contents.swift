//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/// merge
testSample(label: "18_delayPublisher01") {
    let sourcePublisher = PassthroughSubject<Date, Never>()
    
    sourcePublisher
        .sink { completion in
            print("sourcePublisher: \(completion)")
        } receiveValue: { value in
            print("sourcePublisher receive value: \(value)")
        }.store(in: &subscriptions)
    
    // 延后多久执行订阅
    sourcePublisher
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .sink { completion in
            print("     delay Publisher: \(completion)")
        } receiveValue: { value in
            print("     delay Publisher receive value: \(value)")
        }.store(in: &subscriptions)
    
    Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .subscribe(sourcePublisher)
        .store(in: &subscriptions)
    
    /// 执行顺序 Timer Publisher -> sourcePublisher -> delayPublisher -> subscriber
    
}
