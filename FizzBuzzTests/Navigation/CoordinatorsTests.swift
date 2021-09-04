//
//  CoordinatorsTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 02/09/2021.
//

import XCTest

@testable import FizzBuzz
class CoordinatorsTests: XCTestCase {

    func test_coordinatorExtension() {
        
        let sut = CoordinatorSpy()
        let nav = sut.navigationController
        XCTAssertNotNil(nav)
        
    }

}

fileprivate class CoordinatorSpy: Coordinator {
    var rootController: UIViewController = UINavigationController()
    
    func start() -> UIViewController {
        return rootController
    }
    
}
