//
//  TabBarControllerTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 01/09/2021.
//

import XCTest

@testable import FizzBuzz
class TabBarControllerTests: XCTestCase {
    
    func test_animationDirection() {
        
        let sut = TabBarController()
        
        guard let animator = sut.tabBarController(
                sut,
                animationControllerForTransitionFrom: UIViewController(),
                to: StatsController().embedInNav()) as? TabBarControllerAnimator else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(animator.direction, .fromRight)
        
    }
    
}

