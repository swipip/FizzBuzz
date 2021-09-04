//
//  ViewControllerHelpers.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 02/09/2021.
//

import UIKit

extension UIViewController {
    func embedInNav() -> UINavigationController {
        UINavigationController(rootViewController: self)
    }
}
