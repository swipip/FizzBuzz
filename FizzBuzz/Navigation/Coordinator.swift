//
//  Coordinator.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 02/09/2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var rootController: UIViewController { get set }
    func start() -> UIViewController
}
extension Coordinator {
    ///Returns a navigation controller should the rootview controller be one
    var navigationController: UINavigationController? {
        return (rootController as? UINavigationController)
    }
}
