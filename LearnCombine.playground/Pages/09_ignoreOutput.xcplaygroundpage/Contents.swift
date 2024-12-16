//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

testSample(label: "09_ignoreOutput01") {
    let publisher = [1,2,3,4,5].publisher
    
    publisher
        .ignoreOutput()
        .sink { completion in
            print("09_ignoreOutput01 completion:\(completion)")
        } receiveValue: { value in
            print("09_ignoreOutput01 revice value :\(value)")
        }.store(in: &subscriptions)

}
