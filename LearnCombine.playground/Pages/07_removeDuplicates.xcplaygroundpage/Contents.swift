//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// removeDuplicates 删除掉相邻相同的元素
testSample(label: "06_removeDuplicates01") {
    let publisher = [1, 1, 1,13, 40, 1, 45, 45, 300, 500, 45].publisher
    
    publisher
        .removeDuplicates()
        .sink { completion in
            print("06_removeDuplicates01 completion:\(completion)")
        } receiveValue: { value in
            print("06_removeDuplicates01 recive value \(value)")
        }.store(in: &subscriptions)
    
}

// .removeDuplicates(by: { lastVal, currVal in }
// 相邻元素相同的话 执行By Block内的条件判断
//  params1：通过过滤器的发布者发出的前一个值。
//  params2: 被检查的发布者发出的当前值。
testSample(label: "06_removeDuplicates02") {
    let publisher = PassthroughSubject<Int, Never>()
    
    publisher
        .removeDuplicates(by: { Val, currVal in
            let diff = abs(Val - currVal)
            print("06_removeDuplicates02 diff:\(diff) Val:\(Val) currVal:\(currVal)")
//            return diff <= 10 // 当差值小于等于 10 时，认为是重复值,会被过滤
            if diff > 10 {
                return true
            }
            return false
        })
        .sink { completion in
            print("06_removeDuplicates02 completion:\(completion)")
        } receiveValue: { value in
            print("06_removeDuplicates02 recive value \(value)")
        }.store(in: &subscriptions)
    
    publisher.send(2)  // 直接接收值             触发receiveValue
    publisher.send(10) // 前一个值是2 当前值是10  触发receiveValue
    publisher.send(40) // 前一个值是10 当前值40   不会触发 receiveValue
    publisher.send(40)
    publisher.send(40)
    publisher.send(60)
    publisher.send(60)
    
    publisher.send(completion: .finished)
    
    // 逻辑比较混乱  不建议这么使用  只建议用来使用过滤相邻相同的值
    
}

// 只是移除相邻元素， 无法过滤所有重复元素
testSample(label: "06_removeDuplicates03") {
    struct Person {
        let id: Int
        let name: String
    }

    let people = [
        Person(id: 1, name: "Alice"),
        Person(id: 1, name: "Alice"),
        Person(id: 2, name: "Bob"),
        Person(id: 1, name: "Alice1")
    ].publisher

    people
        .removeDuplicates(by: { $0.id == $1.id }) // 根据 `id` 去重
        .sink { person in
            print(person.name)
        }
        .store(in: &subscriptions)
}
