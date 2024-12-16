//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/// merge
testSample(label: "15_merge01") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    publisher1
        .merge(with: publisher2)
        .sink { completion in
            print("15_merge01 completion:\(completion)")
        } receiveValue: { value in
            print("15_merge01 revice value :\(value)")
        }.store(in: &subscriptions)
    
    publisher1.send(100)
    publisher2.send(200)
    publisher2.send(500)
    publisher1.send(900)
    publisher1.send(100)
    publisher2.send(1000)
    
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished) // 此次回调 不糊触发 sink 的 completion

}
