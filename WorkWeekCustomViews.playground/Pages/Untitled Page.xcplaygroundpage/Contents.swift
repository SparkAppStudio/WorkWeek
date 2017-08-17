//: [Previous](@previous)

import UIKit

class MyNav: UINavigationController {

}

class ButtonView: UIButton {
    var color: UIColor = .red

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { fatalError() }

        ctx.setFillColor(color.cgColor)
        ctx.fill(rect)
    }
}

class MyVC: UIViewController {

    let rbuttonView = ButtonView(frame: CGRect(x: -100, y: 0, width: 100, height: 1000))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My View Controller"
        let buttonView = ButtonView(frame: CGRect(x: -100, y: 0, width: 100, height: 1000))
        buttonView.color = .red
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonView)

        let rbuttonView = ButtonView(frame: CGRect(x: -100, y: 0, width: 100, height: 1000))
        rbuttonView.color = .green
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rbuttonView)
        rbuttonView.addTarget(self, action: #selector(MyVC.rightButton(_:)), for: .touchUpInside)
    }

    @objc func rightButton(_ sender: UIBarButtonItem) {
        if rbuttonView.color == .green {
            rbuttonView.color = .purple
        } else {
            rbuttonView.color = .green
        }
        print("Right Button Clicked")
    }

}


import PlaygroundSupport

let myVC = MyVC(nibName: nil, bundle: nil)
let nav = MyNav(rootViewController: myVC)
PlaygroundPage.current.liveView = nav

//: [Next](@next)
