import UIKit

extension UIColor {
    public var colorComponents: [CGFloat] {
        var output = [CGFloat]()
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        output.append(red)
        output.append(green)
        output.append(blue)
        // NOTE: Alpha is unused
        return output
    }
}
