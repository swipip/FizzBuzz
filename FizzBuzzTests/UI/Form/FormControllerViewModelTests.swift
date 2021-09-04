//
//  FormControllerViewModelTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 01/09/2021.
//

import XCTest

@testable import FizzBuzz
class FormControllerViewModelTests: XCTestCase {

    func test_InstructionUpdate() {
        
        let sut = FormControllerViewModel()
        
        var instruction = FormInstruction(.firstInt)
        try? instruction.setValue("10")
        sut.updateInstruction(instruction)
        
        XCTAssertEqual(
            sut.instructions.first(where: {$0.type == .firstInt})?.value, "10")
        
    }
    
    func test_formValidation() {
        let sut = FormControllerViewModel()
        
        sut.instructions = [.init(.firstInt)]
        XCTAssertEqual(sut.checkFormIsValid(), false)
        
        var validInstruction = FormInstruction(.firstInt)
        try? validInstruction.setValue("3")
        
        sut.instructions = [validInstruction]
        
        XCTAssertEqual(sut.checkFormIsValid(), true)
    }
    
    func test_reset() {
        
        let sut = FormControllerViewModel()
        
        var form = FormInstruction(.firstInt)
        try? form.setValue("10")
        sut.updateInstruction(form)
        
        XCTAssertEqual(sut.instructions.first(where: {$0.type == .firstInt})?.value, "10")
        
        sut.resetForm()
        
        XCTAssertEqual(sut.instructions.first(where: {$0.type == .firstInt})?.value, "")
    }

}
