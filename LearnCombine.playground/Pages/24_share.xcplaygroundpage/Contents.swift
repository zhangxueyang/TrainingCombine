//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

testSample(label: "20_collcecTimeValue01") {
    
    let publisher = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .map({ _ in
            return Int.random(in: 1...1000)
        })
        .share()
//     stream1 stream2接收到的值是相同的
//     使用share 个人理解为： 引用类型
//     不使用share 为值类型  新建一个subscriptions
    
    
    publisher.sink { value in
        print("stream1 receveValue: \(value)")
    }.store(in: &subscriptions)
    
    publisher.sink { value in
        print("stream2 receveValue: \(value)")
    }.store(in: &subscriptions)
    

}
    
