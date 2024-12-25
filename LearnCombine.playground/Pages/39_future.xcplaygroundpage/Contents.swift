//: [Previous](@previous)

import Foundation
import Combine

let futurePublisher = Future<String, Never> { promise in
    promise(.success("hello combine"))
}.map {
    $0 + "I am future"
}

futurePublisher
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("39_future01 completion == \(completion) \n")
        case .failure(let error):
            print("39_future01 error == \(error)")
        }
    }, receiveValue: { value in
        print("39_future01 receiveValue == \(value)")
    })

enum MyError: Error {
    case unkonw
}

let hadError = false
var subscriptions = Set<AnyCancellable>()

func futureTask() -> Future<String, MyError> {
    Future<String, MyError> { promise in
        print(Thread.current)
        Thread.sleep(forTimeInterval: 3)
        if !hadError {
            let processName = ProcessInfo.processInfo.processName
            promise(.success(processName))
        } else {
            promise(.failure(MyError.unkonw))
        }
    }
}

testSample(label: "39_future02") {
    futureTask()
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("38_future02 == \(completion)")
            case .failure(let error):
                print("39_future02 error == \(error)")
            }
        }, receiveValue: { value in
            print("39_future02 receiveValue == \(value)")
        }).store(in: &subscriptions)
}
