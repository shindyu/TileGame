import UIKit

extension UIColor {
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    var flatRed: UIColor {
        get {
            return UIColor.rgb(r: 244, g: 67, b: 100, alpha: 1.0)
        }
    }
    var flatBlue: UIColor {
        get {
            return UIColor.rgb(r: 52, g: 152, b: 219, alpha: 1.0)
        }
    }
    var flatGreen: UIColor {
        get {
            return UIColor.rgb(r: 46, g: 204, b: 113, alpha: 1.0)
        }
    }
    var flatYellow: UIColor {
        get {
            return UIColor.rgb(r: 255, g: 230, b: 10, alpha: 1.0)
        }
    }
}
