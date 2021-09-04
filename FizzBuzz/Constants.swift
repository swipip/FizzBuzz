//
//  Constants.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 31/08/2021.
//

import UIKit

struct K {
    static let images = Images()
}
struct Images {
    let gamePad = UIImage(named: "gamepad-alt-light")
    let gamePadFill = UIImage(named: "gamepad-alt-solid")
    let chart = UIImage(named: "chart-bar-light")
    let reset = UIImage(named: "return")
}
extension UIColor {
    static var fbBlue: UIColor {
        return UIColor(named: "blue")!
    }
    static var fbRed: UIColor {
        return UIColor(named: "red")!
    }
    static var fbGreen: UIColor {
        return UIColor(named: "green")!
    }
    static var fbPurple: UIColor {
        return UIColor(named: "purple")!
    }
}

