//
//  AppCoordinatorTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 02/09/2021.
//

import XCTest

@testable import FizzBuzz
class AppCoordinatorTests: XCTestCase {

    
    func test_programmaticNavigation() {
        
        let sut = AppCoordinator()
        let tabBarController = sut.start() as? TabBarController
        
        sut.flow(to: .form)
        XCTAssertEqual(tabBarController?.selectedIndex, 0)
        
        sut.flow(to: .stats)
        XCTAssertEqual(tabBarController?.selectedIndex, 1)
        
    }
    
}
