//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

testSample(label: "04_replace01") {
    let sourcePublisher = [0, 100, nil, 200].publisher
    sourcePublisher
        .replaceNil(with: 9999)
        // 解包，可以将受到的值解包
//        .compactMap{ $0 }
        .sink { completion in
            print("04_replace completion:\(completion)")
        } receiveValue: { value in
            print("04_replace value : \(value)")
        }.store(in: &subscriptions)
    
}

testSample(label: "04_replace02") {
    let sourcePublisher = Empty<Int, Never>()
    sourcePublisher
        .replaceEmpty(with: 99)
        .sink { completion in
            print("04_replace completion:\(completion)")
        } receiveValue: { value in
            print("04_replace value : \(value)")
        }.store(in: &subscriptions)
}

testSample(label: "04_replace02") {
    let sourcePublisher = [].publisher
    sourcePublisher
        .replaceEmpty(with: 99)
        .sink { completion in
            print("04_replace completion:\(completion)")
        } receiveValue: { value in
            print("04_replace value : \(value)")
        }.store(in: &subscriptions)
}
