//
//  FormInstructionTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 01/09/2021.
//

import XCTest

@testable import FizzBuzz
class FormInstructionTests: XCTestCase {

    func test_dataValidationIntInstructions() {
        
        let intInstructions: [FormInstruction] = [
            .init(.firstInt),
            .init(.secondInt),
            .init(.limit)
        ]
        
        for instruction in intInstructions {
            var sut = instruction
            XCTAssertThrowsError(try sut.setValue("string"))
            XCTAssertThrowsError(try sut.setValue("0"))
            XCTAssertNoThrow(try sut.setValue("1"))
        }
        
    }

    func test_dataValidationStringInstructions() {
        
        let stringInstructions: [FormInstruction] = [
            .init(.firstString),
            .init(.secondString)
        ]
        
        for instruction in stringInstructions {
            var sut = instruction
            XCTAssertNoThrow(try sut.setValue("string"))
            XCTAssertNoThrow(try sut.setValue("0"))
            XCTAssertNoThrow(try sut.setValue("1"))
        }
        
    }
}
