//
//  FormTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 01/09/2021.
//

import XCTest

@testable import FizzBuzz
class FormTests: XCTestCase {

    func test_name() {
        
        var sut = Form.new()
        sut.string1 = "fizz"
        sut.string2 = "buzz"
        
        XCTAssertEqual(sut.name, "0 • 0 • 0 • fizz • buzz")
        
    }

    func test_OutPutString() {
        let sut = Form(int1: 3, int2: 5, limit: 20, string1: "a", string2: "z")
        
        let test = ["az","1","2","a","4","z","a","7","8","a","z","11","a","13","14","az","16","17","a","19","z"]
        
        XCTAssertEqual(sut.correctOuputs, test)
    }
}
