//
//  FormControllerTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 01/09/2021.
//

import XCTest

@testable import FizzBuzz
class FormControllerTests: XCTestCase {

    func test_updateFormModel() {
        
        let sut = FormController()
        
        let instructions: [FormInstruction] = [
            FormInstruction(.firstInt),
            FormInstruction(.secondInt),
            FormInstruction(.limit),
            FormInstruction(.firstString),
            FormInstruction(.secondString)
        ]
        
        for instruction in instructions {
            var instruction = instruction
            try? instruction.setValue("4")
            try? instruction.setValue("string")
            
            sut.formCell(didUpdateTextField: instruction, isValueValid: true)
            
            switch instruction.type {
            case .firstInt:
                XCTAssertTrue(sut.viewModel.form.int1 != 0)
            case .secondInt:
                XCTAssertTrue(sut.viewModel.form.int2 != 0)
            case .limit:
                XCTAssertTrue(sut.viewModel.form.limit != 0)
            case .firstString:
                XCTAssertTrue(sut.viewModel.form.string1 != "")
            case .secondString:
                XCTAssertTrue(sut.viewModel.form.string2 != "")
            }

        }
    }
    
    func test_numberOfCells() {
        let sut = FormController()
        
        let numberOfItems = sut.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        
        XCTAssertEqual(numberOfItems, sut.viewModel.instructions.count)
    }
    
    func test_cellDequeuing() {
        let sut = FormController()
        
        let cell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? FormCell
        
        XCTAssertNotNil(cell?.instruction)
        XCTAssertNotNil(cell?.delegate)
    }
    
    func test_navigation() {
        
        let sut = FormControllerSpy()
        
        let expectation = self.expectation(description: "wait for game controller call")
        
        sut.didRequestGameController = {
            expectation.fulfill()
        }
        
        guard let cell = Bundle.main.loadNibNamed("FormCell", owner: nil, options: [:])?.first as? FormCell else {
            XCTFail()
            return
        }
        cell.setInstruction(FormInstruction(.secondString))
        
        sut.didPressNextButton(cell: cell)
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error)
        }
    }
}

fileprivate class FormControllerSpy: FormController {
    
    var didRequestGameController: (()->())?
    
    override func presentGameController() {
        didRequestGameController?()
    }
    
}
