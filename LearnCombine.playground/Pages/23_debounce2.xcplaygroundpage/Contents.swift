//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import Combine

class InputViewController: UIViewController {
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置背景颜色
        view.backgroundColor = .white
        
        let textLabel = UILabel(frame: CGRect(x: 50, y: 100, width: 250, height: 40))
        textLabel.textColor = .red
        textLabel.textAlignment = .center
        textLabel.backgroundColor = .lightGray
        view.addSubview(textLabel)

        let textField = UITextField()
        // 创建 UITextField
        textField.frame = CGRect(x: 50, y: 160, width: 250, height: 40)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter text here"
        textField.textColor = .black
        // 添加到视图中
        view.addSubview(textField)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
            .compactMap({ ($0.object as? UITextField)?.text })
            .sink { completion in
                print("UITextField end input")
            } receiveValue: { value in
                print("debounce receiveValue \(value)")
                textLabel.text = value
            }.store(in: &subscriptions)
    }
    
}

PlaygroundPage.current.liveView = InputViewController()
