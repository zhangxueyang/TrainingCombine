
import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

struct Chatter {
    public let name: String
    public let message: CurrentValueSubject<String, Never>
    
    init(name: String, message: String) {
        self.name = name
        self.message = CurrentValueSubject(message)
    }
}

testSample(label: "03_FlatMap01") {
    let personA = Chatter(name: "personA", message: "i am person a")
    let personB = Chatter(name: "personB", message: "hi person A, i am person b")
    
    let chat = CurrentValueSubject<Chatter, Never>(personA)
    
    chat.sink { complection in
        print("03_FlatMap01 completion:\(complection)")
    } receiveValue: { value in
        print("03_FlatMap01 value : \(value.name) say: \(value.message.value)")
    }.store(in: &subscriptions)
    
    // 不会监听 到message 变化
    personA.message.value = "Hello"
    
    // 只会监听到 Chatter变化
    chat.value = personB
    personB.message.value = "person a, nice to meet you"
    
}

testSample(label: "03_FlatMap02") {
    let personA = Chatter(name: "personA", message: "i am person a")
    let personB = Chatter(name: "personB", message: "hi person A, i am person b")
    
    let chat = CurrentValueSubject<Chatter, Never>(personA)
    
    chat.flatMap({ output -> CurrentValueSubject<String, Never> in
            return output.message
        })
    .sink { complection in
        print("03_FlatMap02 completion:\(complection)")
    } receiveValue: { value in
        print("03_FlatMap02 value :\(value)")
    }.store(in: &subscriptions)
    
    personA.message.value = "Hello EveryBody"
    chat.value = personB
    personB.message.value = "person a, nice to meet you"
    
}

testSample(label: "03_FlatMap03") {
    let personA = Chatter(name: "personA", message: "i am person a")
    let personB = Chatter(name: "personB", message: "hi person A, i am person b")
    let personC = Chatter(name: "personC", message: "hi , i am person C")
    
    let chat = CurrentValueSubject<Chatter, Never>(personA)

//    chat.flatMap(maxPublishers: .max(2), { output -> CurrentValueSubject<String, Never> in
//        return output.message
//    })
    
    /// flatMap： maxPublishers 在于控制，chat增加上流 Publisher 的数量。
    chat.flatMap(maxPublishers: .max(2)) {
        $0.message
    }
    .sink { complection in
        print("03_FlatMap02 completion:\(complection)")
    } receiveValue: { value in
        print("03_FlatMap02 value :\(value)")
    }.store(in: &subscriptions)
    
    personA.message.value = "Hello EveryBody"
    chat.value = personB
    personB.message.value = "person a, nice to meet you"
    
    chat.value = personC
    personC.message.value = "person c say"
    
}
