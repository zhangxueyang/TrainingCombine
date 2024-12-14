//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

testSample(label: "02_map01") {
    let arrPublisher = [100, 200, 300, 20, 14].publisher
    arrPublisher
        .map{ "Trasnfrom:\($0)" }
        .sink { completion in
            print("02_map completion:\(completion)")
        } receiveValue: { value in
            print("02_map value : \(value)")
        }.store(in: &subscriptions)
    
}

testSample(label: "02_map02") {
    enum MyError: Error {
        case wrongData
    }
    
    let arrPublisher = [100, 200, 300, 20, 14].publisher
    arrPublisher.tryMap { value -> String in
        if value == 300 {
            throw MyError.wrongData
        }
        return "Trasnfrom:\(value)"
    }
    .sink { completion in
        switch completion {
        case .finished:
            print("02_map02 completion: \(completion)")
        case .failure(let error):
            print("02_map02 completion: \(error)")
        }
    } receiveValue: { value in
        print("02_map value : \(value)")
    }.store(in: &subscriptions)
    
}


testSample(label: "02_map03") {
    struct Person {
        var name : String
        var age : Int
        var nickName : String?
    }
    
    let sourcePublisher = PassthroughSubject<Person, Never>()
    sourcePublisher
        .map(\.name, \.age, \.nickName)
        .sink { completion in
            print("02_map03 completion:\(completion)")
        } receiveValue: { name, age, nickName  in
            print("02_map03 value : name:\(name) age:\(age) nickName:\(nickName ?? "placehorder")")
        }.store(in: &subscriptions)
    
    sourcePublisher.send(Person(name: "liu", age: 15))
    sourcePublisher.send(Person(name: "zhang", age: 15, nickName: "xiaolei"))
    
}
