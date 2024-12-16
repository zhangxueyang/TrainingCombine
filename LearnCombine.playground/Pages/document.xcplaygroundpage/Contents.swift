//: [Previous](@previous)

import Foundation

/// Drop 和 prefix 的区别
/// Drop: 过滤前边几个的值，或者 自定义条件为true时，就过滤掉，直到自定义条件为fasle时，再开始触发 receiveValue
/// prefix： 保留前边的值  或者  自定义条件为true时，保留其值，并触发receiveValue，当自定义条件为false时就直接忽略值，并且后续不再触发
 
