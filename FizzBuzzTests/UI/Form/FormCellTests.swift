//
//  FormCellTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 01/09/2021.
//

import XCTest

@testable import FizzBuzz
class FormCellTests: XCTestCase {

    var cell: FormCell!
    
    override func setUp() {
        super.setUp()
        guard let cell = Bundle.main.loadNibNamed("FormCell", owner: nil, options: [:])?.first as? FormCell else {
            XCTFail()
            return
        }
        self.cell = cell
    }
    
    func test_TextValidationIntValue() {
        
        let sut = cell!
        
        let instructions = [
            FormInstruction(.firstInt),
            FormInstruction(.secondInt),
            FormInstruction(.limit)]
            
        for instruction in instructions {
            sut.setInstruction(instruction)
            
            let tests: [String?: Bool] = [
                "string":false,
                "": false,
                nil: false,
                "0": false,
                "1": true]
            
            for (value, test) in tests {
                XCTAssertEqual(test, sut.validateTextField(value))
            }
        }
        
    }
    
    func test_TextValidationStringValue() {
        
        let sut = cell!
        
        let instructions = [
            FormInstruction(.firstString),
            FormInstruction(.secondString)
        ]
        
        for instruction in instructions {
            sut.setInstruction(instruction)
            
            let tests: [String?: Bool] = [
                "string":true,
                "": false,
                nil: false,
                "0": true,
                "1": true]
            
            for (value, test) in tests {
                XCTAssertEqual(test, sut.validateTextField(value))
            }
        }
    }
    
    func test_textFieldUpdate() {
        
        let sut = cell!
        
        let instruction = FormInstruction(.firstString)
        sut.setInstruction(instruction)
        
        let textField = UITextField()
        textField.text = "hello"
        
        sut.textFieldDidChangeSelection(textField)
     
        XCTAssertEqual(sut.instruction?.value, "hello")
    }
    
    func test_textFieldNoUpdateWhenNotValid() {
        let sut = cell!
        
        let instruction = FormInstruction(.firstInt)
        sut.setInstruction(instruction)
        
        let textField = UITextField()
        textField.text = "hello"
        
        sut.textFieldDidChangeSelection(textField)
     
        XCTAssertEqual(sut.instruction?.value, "")
    }
    
    func test_validationWhenButtonPressed() {
        let sut = cell!
        let spy = FormCellDelegateSpy()
        sut.delegate = spy
        
        let instruction = FormInstruction(.firstInt)
        sut.setInstruction(instruction)
        
        sut.nextButtonPressed(UIButton())
        
        XCTAssertFalse(spy.buttonPressedSuccess)
        
        let tf = UITextField()
        tf.text = "12"
        sut.textFieldDidChangeSelection(tf)
        sut.nextButtonPressed(UIButton())
        
        XCTAssertTrue(spy.buttonPressedSuccess)
    }
    
    func test_prepareForReuse() {
        let sut = cell!
        
        sut.textField.text = "test"
        sut.animateWrong()
        
        sut.prepareForReuse()
        
        XCTAssertEqual(sut.highlightView.backgroundColor, .fbBlue)
        XCTAssertEqual(sut.textField.text, "")
    }
}
fileprivate class FormCellDelegateSpy: FormCellDelegate {
    var buttonPressedSuccess = false
    
    func formCell(didUpdateTextField instruction: FormInstruction?, isValueValid: Bool) {
        //
    }
    
    func didPressNextButton(cell: FormCell) {
        buttonPressedSuccess = true
    }
}
