import Foundation
import Combine

public func testSample(label: String, testBlock: () -> Void) {
    print("Begin Test Name：\(label)")
    testBlock()
    print("End  Test Name：\(label)", terminator: "\n\n")
}

/// 扩展了PassthroughSubject,模拟输入。
public extension PassthroughSubject {
    func feed(with input: [(Double , Output)]) {
        let now = DispatchTime.now()
        for e in input {
            let when = now + DispatchTimeInterval.milliseconds(Int(e.0*1000))
            // 这里的 asyncAfter 不能保证执行顺序；如果想保证 执行的顺序，需要设计别的机制。
            DispatchQueue.global().asyncAfter(deadline: when) {
                self.send(e.1)
            }
        }
    }
}
