//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import Combine

var subscriptions = Set<AnyCancellable>()

// debounce 一段时间内执行一次 通常用户处理用户输入实施校验需求s
testSample(label: "21_collect_time1") {
    let publisher = PassthroughSubject<String, Never>()
    
    publisher.sink { completion in
        print("21_collect_time1: \(completion)")
    } receiveValue: { value in
        print("21_collect_time1 receiveValue: \(value)")
    }.store(in: &subscriptions)

    let debounce = publisher
        .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
        .share()
    
    debounce
        .sink { completion in
            print("    debounce: \(completion)")
        } receiveValue: { value in
            print("    debounce receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    let input: [(Double, String)] = [
        (0.0, "y"),
        (0.1, "yo"),
        (0.2, "you"),
        (2.6, "your b"),
        (2.7, "your ba"),
        (2.8, "your bab"),
        (3.5, "your baby"),
    ]
    
    publisher.feed(with: input)
}

