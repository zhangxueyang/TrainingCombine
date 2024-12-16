//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/// prepend 往前边插入数值
testSample(label: "12_prepend01") {
    let publisher = [1,2,3,4,5].publisher
    
    publisher
        .prepend(5,6)
        .sink { completion in
            print("12_prepend01 completion:\(completion)")
        } receiveValue: { value in
            print("12_prepend01 revice value :\(value)")
        }.store(in: &subscriptions)

}

testSample(label: "12_prepend02") {
    let publisher = PassthroughSubject<Int,Never>()
    
    publisher
        .prepend(5,6)
        .sink { completion in
            print("12_prepend02 completion:\(completion)")
        } receiveValue: { value in
            print("12_prepend02 revice value :\(value)")
        }.store(in: &subscriptions)
    
    
    // 这里不执行 prepend数据也会被发送
//    publisher.send(1)
//    publisher.send(2)
//    publisher.send(3)
//    publisher.send(4)
//    publisher.send(completion: .finished)

}

testSample(label: "12_prepend03") {
    let publisher = PassthroughSubject<Int,Never>()
    
    // 可以传数组
    publisher
        .prepend([5,6,7])
        .sink { completion in
            print("12_prepend03 completion:\(completion)")
        } receiveValue: { value in
            print("12_prepend03 revice value :\(value)")
        }.store(in: &subscriptions)
    
    publisher.send(1)
    publisher.send(2)
    publisher.send(3)
    publisher.send(4)
    publisher.send(completion: .finished)

}

testSample(label: "12_prepend04") {
    let publisher = PassthroughSubject<Int,Never>()
    let publisher2 = [10,20,30,40].publisher
    
    // 参数可以是 publisher
    publisher
        .prepend(publisher2)
        .sink { completion in
            print("12_prepend04 completion:\(completion)")
        } receiveValue: { value in
            print("12_prepend04 revice value :\(value)")
        }.store(in: &subscriptions)
    
    publisher.send(1)
    publisher.send(2)
    publisher.send(3)
    publisher.send(4)
    publisher.send(completion: .finished)

}

testSample(label: "12_prepend05") {
    let publisher1 = PassthroughSubject<Int,Never>()
    let publisher2 = PassthroughSubject<Int,Never>()
    
    publisher1
        .prepend(publisher2)
        .sink { completion in
            print("12_prepend05 completion:\(completion)")
        } receiveValue: { value in
            print("12_prepend05 revice value :\(value)")
        }.store(in: &subscriptions)
    
    // 不会接收到
    publisher1.send(5)
    publisher1.send(6)
    
    // 需要先等 publisher2 发送数据 并发送finished后， publisher1才会被接受数据
    publisher2.send(3)
    publisher2.send(4)
    publisher2.send(completion: .finished)
    
    publisher1.send(1)
    publisher1.send(2)

}

testSample(label: "12_prepend06") {
    let publisher1 = PassthroughSubject<Int,Never>()
    let publisher2 = PassthroughSubject<Int,Never>()
    
    publisher1
        .prepend(publisher2)
        .sink { completion in
            print("12_prepend06 completion:\(completion)")
        } receiveValue: { value in
            print("12_prepend06 revice value :\(value)")
        }.store(in: &subscriptions)
    
    // 不会接收到
    publisher1.send(5)
    publisher1.send(6)
    
    // 需要先等 publisher2 发送数据 并发送finished后， publisher1才会被接受数据
    publisher2.send(3)
    publisher2.send(4)
    publisher2.send(completion: .finished)
    
    publisher1.send(1)
    publisher1.send(2)

}
