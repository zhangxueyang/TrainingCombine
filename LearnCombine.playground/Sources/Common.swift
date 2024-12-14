import Foundation

public func testSample(label: String, testBlock: () -> Void) {
    print("Begin Test Name：\(label)")
    testBlock()
    print("End  Test Name：\(label)", terminator: "\n\n")
}
