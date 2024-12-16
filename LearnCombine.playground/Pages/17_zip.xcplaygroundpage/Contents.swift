//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/// merge
testSample(label: "17_zip01") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    publisher1
        .zip(publisher2)
        .sink(receiveCompletion: { completion in
            print("17_zip01 completion:\(completion)")
        }, receiveValue: { val1, val2 in
            print("17_zip01 receive value ———— value1:\(val1) val2:\(val2)")
        }).store(in: &subscriptions)
    
    publisher1.send(12)
    publisher2.send("a")
    publisher1.send(300)
    publisher2.send("b")
    publisher2.send("c")
//    publisher1.send(400)
    
//    必须两两组合
//    Begin Test Name：17_zip01
//    17_zip01 receive value ———— value1:12 val2:a
//    17_zip01 receive value ———— value1:300 val2:b
//    17_zip01 completion:finished
//    End  Test Name：17_zip01

    // 合并两个Publisher  两个收到的值组合输出，输出后会值不会再被接受。
    publisher1.send(completion: .finished)
}
