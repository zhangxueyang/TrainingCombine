//: [Previous](@previous)

import Foundation
import Combine

struct MyDate: Comparable {
    var year: Int
    var month: Int
    var day: Int
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }
    
    static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs < rhs || lhs == rhs
    }
    
    static func > (lhs: Self, rhs: Self) -> Bool {
        return !(lhs <= rhs)
    }
    
    static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs > rhs ||  lhs == rhs
    }
    
}


testSample(label: "37_sequence01") {
    let date1 = MyDate(year: 2024, month: 12, day: 1)
    let date2 = MyDate(year: 2023, month: 12, day: 1)
    let date3 = MyDate(year: 2024, month: 12, day: 4)
    let date4 = MyDate(year: 2024, month: 11, day: 1)
    
    let dates = [date1, date2, date3, date4]
    
    // 降序
    print(dates.sorted{ $0 > $1 })
    
}

var subscriptions = Set<AnyCancellable>()

testSample(label: "37_sequence02") {
    let date1 = MyDate(year: 2024, month: 12, day: 1)
    let date2 = MyDate(year: 2023, month: 12, day: 1)
    let date3 = MyDate(year: 2024, month: 12, day: 4)
    let date4 = MyDate(year: 2024, month: 11, day: 1)
    
    let dates = [date1, date2, date3, date4]
    
    dates
        .publisher
        .min()
        .sink { completion in
            print("36_reduce01: \(completion)")
        } receiveValue: { value in
            print("36_reduce01 receiveValue: \(value)") // 只接受一次数据
        }.store(in: &subscriptions)
    
}
