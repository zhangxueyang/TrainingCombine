//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()


//.collect(.byTime(DispatchQueue.main, .seconds(4)))
//.flatMap { dates in
//    dates.publisher
//}
// 将在四秒内收集到的数组展开逐条发送数据
testSample(label: "20_collcecTimeValue01") {
    let sourcePublisher = PassthroughSubject<Date, Never>()
    
    sourcePublisher
        .sink { completion in
            print("sourcePublisher: \(completion)")
        } receiveValue: { value in
            print("sourcePublisher receiveValue: \(value)")
        }.store(in: &subscriptions)
    
    sourcePublisher
        .collect(.byTime(DispatchQueue.main, .seconds(4)))
        .flatMap { dates in
            dates.publisher
        }
        .sink { completion in
            print("    collect Publisher: \(completion)")
        } receiveValue: { date in
            print("    collect receiveValue: \(date)")
        }.store(in: &subscriptions)

    Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .subscribe(sourcePublisher)
        .store(in: &subscriptions)
    
}
