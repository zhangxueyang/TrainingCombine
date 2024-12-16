//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/// switchToLatest 多个发布者发送数据后，只有最新的发布者才会被处理
testSample(label: "14_switchToLatest01") {
    let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
    
    let aPulblisher = PassthroughSubject<Int, Never>()
    let bPulblisher = PassthroughSubject<Int, Never>()
    let cPulblisher = PassthroughSubject<Int, Never>()
    
    publishers
        .switchToLatest()
        .sink { completion in
            print("14_switchToLatest01 completion:\(completion)")
        } receiveValue: { value in
            print("14_switchToLatest01 revice value :\(value)")
        }.store(in: &subscriptions)
    
    publishers.send(aPulblisher)
    aPulblisher.send(1)
    aPulblisher.send(2)
    
    publishers.send(bPulblisher)
    aPulblisher.send(3) // 已经切换到bPulblisher，aPulblisher发布的数据不再被接受
    bPulblisher.send(4)
    bPulblisher.send(5)
    
    publishers.send(cPulblisher)
    bPulblisher.send(6) // 已经切换到cPulblisher，bPulblisher发布的数据不再被接受
    cPulblisher.send(7)
    cPulblisher.send(8)
    
    // 结束当前处理的 pulblisher， 可选项 不会引发 sink completion回调
    cPulblisher.send(completion: .finished)
    
    // 结束容器的 发送数据
    publishers.send(completion: .finished)
    
}


testSample(label: "14_switchToLatestVoid02") {
    let publishers = PassthroughSubject<PassthroughSubject<Void, Never>, Never>()
    
    let aPulblisher = PassthroughSubject<Void, Never>()
    let bPulblisher = PassthroughSubject<Void, Never>()
    let cPulblisher = PassthroughSubject<Void, Never>()
    
    publishers
        .switchToLatest()
        .sink { completion in
            print("14_switchToLatestVoid02 completion:\(completion)")
        } receiveValue: { value in
            print("14_switchToLatestVoid02 revice value :\(value)")
        }.store(in: &subscriptions)
    
    publishers.send(aPulblisher)
    aPulblisher.send()
    aPulblisher.send()
    
    publishers.send(bPulblisher)
    aPulblisher.send() // 已经切换到bPulblisher，aPulblisher发布的数据不再被接受
    bPulblisher.send()
    bPulblisher.send()
    
    publishers.send(cPulblisher)
    bPulblisher.send() // 已经切换到cPulblisher，bPulblisher发布的数据不再被接受
    cPulblisher.send()
    cPulblisher.send()
    
    // 结束当前处理的 pulblisher， 可选项 不会引发 sink completion回调
    cPulblisher.send(completion: .finished)
    
    // 结束容器的 发送数据
    publishers.send(completion: .finished)
    
}
