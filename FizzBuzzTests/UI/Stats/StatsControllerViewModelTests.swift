//
//  StatsControllerViewModelTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 01/09/2021.
//

import XCTest

@testable import FizzBuzz
class StatsControllerViewModelTests: XCTestCase {

    func test_getRanking() {
        
        let sut = StatsControllerViewModelSpy()
        
        let forms: [Form] = [
            Form(int1: 1, int2: 0, limit: 0, string1: "", string2: ""),
            Form(int1: 1, int2: 0, limit: 0, string1: "", string2: ""),
            Form(int1: 1, int2: 0, limit: 0, string1: "", string2: ""),
            Form(int1: 0, int2: 1, limit: 0, string1: "", string2: ""),
            Form(int1: 0, int2: 1, limit: 0, string1: "", string2: ""),
            Form(int1: 0, int2: 0, limit: 0, string1: "test", string2: "")
        ]
        
        sut.setForms(forms)
        
        for _ in 0...20 {
            sut.getTopForms()
            let ranking = sut.orderedForms
            XCTAssertEqual(ranking.map({$0.hits}), [3,2,1])
        }
        
    }
    
    func test_viewModelDelegateGetForms() {
        let sut = StatsControllerViewModel()
        let spy = StatsControllerViewModelDelegateSpy()
        sut.delegate = spy
        
        let exp = self.expectation(description: "Wait to retrieve forms")
        
        spy.didGetForms = {
            exp.fulfill()
        }
        
        sut.getForms()
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }
    
    func test_viewModelDelegateGetOrderedForms() {
        let sut = StatsControllerViewModel()
        let spy = StatsControllerViewModelDelegateSpy()
        sut.delegate = spy
        
        let exp = self.expectation(description: "Wait to retrieve ordered forms")
        
        spy.didGetOrderedForms = {
            exp.fulfill()
        }
        
        sut.getTopForms()
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }

    func test_maxHitForm() {
        let sut = StatsControllerViewModelSpy()
        
        let forms: [Form] = [
            Form(int1: 1, int2: 0, limit: 0, string1: "", string2: ""),
            Form(int1: 1, int2: 0, limit: 0, string1: "", string2: ""),
            Form(int1: 1, int2: 0, limit: 0, string1: "", string2: ""),
            Form(int1: 0, int2: 1, limit: 0, string1: "", string2: ""),
            Form(int1: 0, int2: 1, limit: 0, string1: "", string2: ""),
            Form(int1: 0, int2: 0, limit: 0, string1: "test", string2: "")
        ]
        
        sut.setForms(forms)
        sut.getTopForms()
        
        XCTAssertEqual(sut.maxHits, 3)
    }
}

fileprivate class StatsControllerViewModelSpy: StatsControllerViewModel {
    
    private var _forms: [Form] = []
    
    override var forms: [Form] {
        get {
            return _forms
        }
    }
    
    func setForms(_ forms: [Form]) {
        self._forms = forms
    }
    
}

fileprivate class StatsControllerViewModelDelegateSpy: StatsControllerViewModelDelegate {
    var didGetForms:(()->Void)?
    var didGetOrderedForms:(()->Void)?
    
    func statsControllerViewModel(didLoadForms forms: [Form]) {
        didGetForms?()
    }
    
    func statsControllerViewModel(didLoadOrdered forms: [(form: Form, hits: Int)]) {
        didGetOrderedForms?()
    }
}
