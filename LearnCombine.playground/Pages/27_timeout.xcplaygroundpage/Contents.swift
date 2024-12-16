//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

enum CustomError: Error {
    case timeout
}

testSample(label: "27_timeout") {
    let publisher = PassthroughSubject<Void, CustomError>()
    
    let timeout = publisher
        .timeout(.seconds(2), scheduler: DispatchQueue.global(), customError: { .timeout })
        .share()
    
    publisher.sink { completion in
        print("27_timeout: \(completion)")
    } receiveValue: { value in
        print("27_timeout receiveValue: \(value)")
    }.store(in: &subscriptions)
    
    timeout.sink { completion in
        print("    timeout: \(completion)")
    } receiveValue: { value in
        print("    timeout receiveValue: \(value)")
    }.store(in: &subscriptions)
    
    Thread.sleep(forTimeInterval: 5)
    publisher.send()
    publisher.send(completion: .finished)
    
}
