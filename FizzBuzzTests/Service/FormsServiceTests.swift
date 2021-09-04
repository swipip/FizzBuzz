//
//  FormsServiceTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 01/09/2021.
//

import XCTest

@testable import FizzBuzz
class FormsServiceTests: XCTestCase {
    
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        
        userDefaults = UserDefaults(suiteName: #file)!
        userDefaults.removePersistentDomain(forName: #file)
        
    }
    
    func test_save() {
        let sut = FormsService(userDefaults)
        
        let exp = self.expectation(description: "wait for save success")
        
        sut.save(Form.new()) { success in
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
        
    }
    
    func test_read() {
        
        let sut = FormsService(userDefaults)
        let forms = Array(repeating: Form.new(), count: 10)
        
        if let data = try? JSONEncoder().encode(forms) {
            userDefaults.setValue(data, forKey: "com.fizzbuzz.gautierbillard")
        } else {
            XCTFail()
        }
        
        let exp = self.expectation(description: "wait for form results")
        var formsCheck = [Form]()
        
        sut.getForms { result in
            switch result {
            case .success(let forms):
                formsCheck = forms
                exp.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
            XCTAssertEqual(forms.count, formsCheck.count)
        }
        
    }

}
