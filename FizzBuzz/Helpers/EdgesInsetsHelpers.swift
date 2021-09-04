//
//  EdgesInsetsHelpers.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 02/09/2021.
//

import UIKit

extension UIEdgeInsets {
    static func all(_ constant: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: constant, left: constant, bottom: constant, right: constant)
    }
}
