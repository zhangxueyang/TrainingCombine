//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/// prefix 操作符用于限制发布者最多发出一组指定数量的值。一旦达到限制，发布者将不再发出新的值。
/// 它可以用于过滤序列的前几个元素，非常适合需要处理有限数量数据流的场景。
testSample(label: "11_prefix01") {
    let publisher = [10,11,13,200,230,2000,102,18].publisher
    
    publisher
        .prefix(4) // 保留前四个值
        .sink { completion in
            print("11_prefix01 completion:\(completion)")
        } receiveValue: { value in
            print("11_prefix01 revice value :\(value)")
        }.store(in: &subscriptions)

}

testSample(label: "11_prefix02") {
    let publisher = [10,11,13,99,102,96,102,18].publisher
    
    publisher
        .prefix(while: { val in
            return val < 100 //为true的时候，会一直调用触发 receiveValue，接着再此执行此判断，当为false的时候，就不会再继续执行下去了
        })
        .sink { completion in
            print("11_prefix02 completion:\(completion)")
        } receiveValue: { value in
            print("11_prefix02 revice value :\(value)")
        }.store(in: &subscriptions)

}


testSample(label: "11_prefix03") {
    let sourcePublisher = PassthroughSubject<Int,Never>()
    let readyPublsher = PassthroughSubject<Void, Never>()
    
    sourcePublisher
        .prefix(untilOutputFrom: readyPublsher)
        .sink { completion in
            print("11_prefix03 completion:\(completion)")
        } receiveValue: { value in
            print("11_prefix03 revice value :\(value)")
        }.store(in: &subscriptions)
    
    (1...5).forEach { val in
        sourcePublisher.send(val)
        if val == 3 {
            readyPublsher.send()
        }
    }
    
}
