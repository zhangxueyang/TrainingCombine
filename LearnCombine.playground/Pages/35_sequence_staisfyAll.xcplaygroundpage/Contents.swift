//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

testSample(label: "35_allSatisfy01") {
    let publisher = PassthroughSubject<String, Never>()
    
    publisher
        .allSatisfy { value in
            value.contains("wode")
        }
        .sink { completion in
            print("35_allSatisfy01: \(completion)")
        } receiveValue: { value in
            // 接收的结果是Bool值
            print("35_allSatisfy01 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    publisher.send("wodefang")
    publisher.send("wodeche")
    publisher.send("wodeiphone")
    publisher.send("wodediannao")
    publisher.send(completion: .finished)
}

enum AllSatisfyError: Error {
    case undefine
}

testSample(label: "35_allSatisfy02") {
    let publisher = PassthroughSubject<String, Never>()
    
    publisher
        .tryAllSatisfy { value in
            if value.contains("che") {
                throw AllSatisfyError.undefine
            }
            return true
        }
        .sink { completion in
            print("35_allSatisfy02: \(completion)")
        } receiveValue: { value in
            // 接收的结果是Bool值
            print("35_allSatisfy02 receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    publisher.send("wodefang")
    publisher.send("wodeche")
    publisher.send("wodeiphone")
    publisher.send("wodediannao")
    publisher.send(completion: .finished)
    
}
