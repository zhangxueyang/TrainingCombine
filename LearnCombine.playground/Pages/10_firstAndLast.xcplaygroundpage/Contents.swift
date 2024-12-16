//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// dropFirst 过滤第一个元素
testSample(label: "10_dropFirst01") {
    let publisher = [1,2,3,4,5].publisher
    
    publisher
        .dropFirst()
        .sink { completion in
            print("10_dropFirst01 completion:\(completion)")
        } receiveValue: { value in
            print("10_dropFirst01 revice value :\(value)")
        }.store(in: &subscriptions)

}

// dropFirst 加参数 过滤前几个元素
testSample(label: "10_dropFirst02") {
    let publisher = [1,2,3,4,5].publisher
    
    publisher
        .dropFirst(3)
        .sink { completion in
            print("10_dropFirst02 completion:\(completion)")
        } receiveValue: { value in
            print("10_dropFirst02 revice value :\(value)")
        }.store(in: &subscriptions)

}

testSample(label: "10_dropFirst03") {
//    一个都不会被过滤掉
//    let publisher = [1,2,3,4,5].publisher
    
    // 会过滤掉4,5
    let publisher = [4,5,1,2,3,4,5].publisher
    
    publisher
        .drop(while: { val in
            print("val == \(val)")
            return val > 3 // 如果返回为true的话 会一直执行 drop 函数, 有一个条件不满足就不再执行此方法, 这里返回true的话，下边就不会触发receiveValue，只有出现一次false，就不会再调用此方法，接下来会一直触发 receiveValue
        })
        .sink { completion in
            print("10_dropFirst03 completion:\(completion)")
        } receiveValue: { value in
            print("10_dropFirst03 revice value :\(value)")
        }.store(in: &subscriptions)

}

testSample(label: "10_drop_04") {
    let sourcePublisher = PassthroughSubject<Int, Never>()
    let readyPublisher = PassthroughSubject<Void, Never>()
    
    sourcePublisher
        .drop(untilOutputFrom: readyPublisher)
        .sink { completion in
            print("10_dropFirst04 completion:\(completion)")
        } receiveValue: { value in
            print("10_dropFirst04 revice value :\(value)")
        }.store(in: &subscriptions)
    
    for item in (0...5) {
        sourcePublisher.send(item)
        if item == 3 {
            // item 等于三的时候开始执行，下次循环的时候 sourcePublisher开始接收数据，从4开始
            readyPublisher.send()
        }
    }
    
}
