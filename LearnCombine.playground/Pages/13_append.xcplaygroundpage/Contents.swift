//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/// append 往执行后插入数值
testSample(label: "13_append01") {
    let publisher = [1,2,3,4,5].publisher
    
    publisher
        .append(8,6,7)
        .sink { completion in
            print("13_append01 completion:\(completion)")
        } receiveValue: { value in
            print("13_append01 revice value :\(value)")
        }.store(in: &subscriptions)
}

testSample(label: "13_append02") {
    let publisher1 = PassthroughSubject<Int, Never>()
    
    publisher1
        .append(8,6,7)
        .sink { completion in
            print("13_append02 completion:\(completion)")
        } receiveValue: { value in
            print("13_append02 revice value :\(value)")
        }.store(in: &subscriptions)
    
    publisher1.send(100)
    publisher1.send(200)
    publisher1.send(300)
    // 只有调用 publisher1 .finished  才会执行后续 append
    publisher1.send(completion: .finished)
    
}

testSample(label: "13_append03") {
    let publisher1 = PassthroughSubject<Int, Never>()
    
    // 参数可以是数组
    publisher1
        .append([8,6,7])
        .sink { completion in
            print("13_append03 completion:\(completion)")
        } receiveValue: { value in
            print("13_append03 revice value :\(value)")
        }.store(in: &subscriptions)
    
    publisher1.send(100)
    publisher1.send(200)
    publisher1.send(300)
    // 只有调用 publisher1 .finished  才会执行后续 append
    publisher1.send(completion: .finished)
    
}

testSample(label: "13_append04") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = [1,2,34,56].publisher
    
    // 参数可以是数组
    publisher1
        .append(publisher2)
        .sink { completion in
            print("13_append04 completion:\(completion)")
        } receiveValue: { value in
            print("13_append04 revice value :\(value)")
        }.store(in: &subscriptions)
    
    publisher1.send(100)
    publisher1.send(200)
    publisher1.send(300)
    // 只有调用 publisher1 .finished  才会执行后续 append
    publisher1.send(completion: .finished)
    
}

testSample(label: "13_append05") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    // 参数可以是数组
    publisher1
        .append(publisher2)
        .sink { completion in
            print("13_append05 completion:\(completion)")
        } receiveValue: { value in
            print("13_append05 revice value :\(value)")
        }.store(in: &subscriptions)
    
    publisher1.send(100)
    publisher1.send(200)
    publisher1.send(300)
    // 只有调用 publisher1 .finished  才会执行后续 append 这里不会触发 completion 回调函数
    publisher1.send(completion: .finished)
    
    publisher2.send(4)
    publisher2.send(5)
    publisher2.send(6)
    publisher2.send(completion: .finished)
    
}
