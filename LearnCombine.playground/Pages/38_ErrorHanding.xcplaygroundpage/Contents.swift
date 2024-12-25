//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

testSample(label: "38_ErrorHanding_setFailureType") {
    let arrPublisher = [1,2,3,4,5].publisher
    let intPublisher = CurrentValueSubject<Int, Error>(100)
    
    arrPublisher
        //combineLatest 必须要保证 Output、Failure 一致, 使用 setFailureType 将 arrPublisher转换为 intPublisher类型
        .setFailureType(to: Error.self) // 统一错误类型的作用
        .combineLatest(intPublisher)
        .sink { completion in
            print("38_ErrorHanding_setFailureType: \(completion)")
        } receiveValue: { value in
            print("38_ErrorHanding_setFailureType receiveValue: \(value)") // 只接受一次数据
        }.store(in: &subscriptions)
    
}

enum MyErrors: Error {
    case wrongError
    case endError
    case defaultError
}

enum YourErrors: Error {
    case wrongError
    case endError
    case defaultError
}

testSample(label: "38_ErrorHanding_assertNoFailure") {
    let intPublisher = PassthroughSubject<Int, Error>()
    
    let errorPublisher = intPublisher
    // 如果检测到Error 直接退出程序 error: Execution was interrupted, reason: EXC_BREAKPOINT (code=1, subcode=0x1b18fd040).
//        .assertNoFailure()
        .eraseToAnyPublisher()

    errorPublisher
        .sink { completion in
            print("38_ErrorHanding_assertNoFailure: \(completion)")
        } receiveValue: { value in
            print("38_ErrorHanding_assertNoFailure receiveValue: \(value)") // 只接受一次数据
        }.store(in: &subscriptions)
    
    intPublisher.send(1)
    intPublisher.send(2)
    
    intPublisher.send(completion: .failure(MyErrors.wrongError))
    
}

testSample(label: "38_ErrorHanding_tryMap") {
    let publisher = [1,2,3,4,5,6,7].publisher
    
    publisher
    // 各种try
        .tryMap { val in
            if val == 5 {
                throw MyErrors.wrongError
            }
            return val
        }
        .sink { completion in
            print("38_ErrorHanding_tryMap: \(completion)")
        } receiveValue: { value in
            print("38_ErrorHanding_tryMap receiveValue: \(value)") // 只接受一次数据
        }.store(in: &subscriptions)
    
}

testSample(label: "38_ErrorHanding_mapError") {
    let publisher = PassthroughSubject<Int, MyErrors>()
    
    publisher
        .tryMap { val in
            if val == 2 {
                throw MyErrors.wrongError
            }
            return val
        }
        .mapError({ myError -> YourErrors in
            guard let error = myError as? MyErrors else {
                return YourErrors.defaultError
            }
            
            switch error {
            case .wrongError:
                return YourErrors.wrongError
            case .endError:
                return YourErrors.endError
            default:
                return YourErrors.defaultError
            }
        })
        .sink(receiveCompletion: { completion in
            print("38_ErrorHanding_mapError: \(completion)")
        }, receiveValue: { value in
            print("38_ErrorHanding_mapError receiveValue: \(value)")
        }).store(in: &subscriptions)
    
    publisher.send(1)
    publisher.send(2)
    publisher.send(completion: .failure(MyErrors.defaultError))
    
}

testSample(label: "38_ErrorHanding_replaceError") {
    let publisher = PassthroughSubject<Int, MyErrors>()
    
    publisher
        .tryMap { val in
            if val == 2 {
                throw MyErrors.wrongError
            }
            return val
        }
        .mapError({ myError -> YourErrors in
            guard let error = myError as? MyErrors else {
                return YourErrors.defaultError
            }
            
            switch error {
            case .wrongError:
                return YourErrors.wrongError
            case .endError:
                return YourErrors.endError
            default:
                return YourErrors.defaultError
            }
        })
        // 将错误转换成 某条数据发送后，结束stream
        .replaceError(with: 10)
        .sink(receiveCompletion: { completion in
            print("38_ErrorHanding_replaceError: \(completion)")
        }, receiveValue: { value in
            print("38_ErrorHanding_replaceError receiveValue: \(value)")
        }).store(in: &subscriptions)
    
    publisher.send(1)
    publisher.send(2)
    publisher.send(2)
    publisher.send(2)
    publisher.send(2)
    
    publisher.send(completion: .failure(MyErrors.defaultError))
    
}


// retry 将上游发布者重新生成发布 重新订阅
testSample(label: "38_ErrorHanding_retry") {
//    let publisher = [1,3,4,2,56].publisher

    let publisher = PassthroughSubject<Int, MyErrors>()
    publisher
        .print("debug-------info")
        .tryMap { (val) -> Int? in
//            print("38_ErrorHanding_retry \(val)")
            if val == 2 {
                throw MyErrors.wrongError
            }
            return val
        }
        .retry(4)
        .sink(receiveCompletion: { completion in
            print("38_ErrorHanding_retry: \(completion)")
        }, receiveValue: { value in
            print("38_ErrorHanding_retry receiveValue: \(value)")
        }).store(in: &subscriptions)
    
    publisher.send(2)
    
    // 发送一个没有错误的值，查看是否会被接收
//    publisher.send(3)
//
//    // 完成发布者
//    publisher.send(completion: .finished)
}
