//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// filter 过滤数据
testSample(label: "06_filter01") {
    let publisher = [1, 13, 40, 45, 300, 500].publisher
    
    publisher
        .filter{ $0 > 40 }
        .sink { completion in
            print("06_filter completion:\(completion)")
        } receiveValue: { value in
            print("06_filter recive value \(value)")
        }.store(in: &subscriptions)

}


testSample(label: "06_filter02") {
    let publisher = PassthroughSubject<Int, Never>()
    
    publisher
        .filter{ $0 > 40 }
        .sink { completion in
            print("06_filter completion:\(completion)")
        } receiveValue: { value in
            print("06_filter recive value \(value)")
        }.store(in: &subscriptions)
    
    publisher.send(10)   
    publisher.send(20)
    publisher.send(30)
    publisher.send(40)
    publisher.send(50)
    publisher.send(60)

    publisher.send(completion: .finished)
}
