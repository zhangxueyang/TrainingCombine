//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

testSample(label: "36_reduce01") {
    let publisher = PassthroughSubject<Int, Never>()
    
    publisher
        .reduce(0) { sum, value in
            return sum + value
        }
        .sink { completion in
            print("36_reduce01: \(completion)")
        } receiveValue: { value in
            print("36_reduce01 receiveValue: \(value)") // 只接受一次数据
        }.store(in: &subscriptions)
    
    publisher.send(1)
    publisher.send(1)
    publisher.send(1)
    publisher.send(completion: .finished)
    
}

testSample(label: "36_reduce02") {
    let publisher = PassthroughSubject<String, Never>()
    
    publisher
        .reduce("") { sum, value in
            return sum.appending(value)
        }
        .sink { completion in
            print("36_reduce01: \(completion)")
        } receiveValue: { value in
            print("36_reduce01 receiveValue: \(value)") // 只接受一次数据
        }.store(in: &subscriptions)
    
    publisher.send("I ")
    publisher.send("am ")
    publisher.send("so cool.")
    publisher.send("I ")
    publisher.send("am ")
    publisher.send("so handsome.")
    publisher.send(completion: .finished)
}
