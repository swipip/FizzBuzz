//
//  StatsControllersTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 02/09/2021.
//

import XCTest

@testable import FizzBuzz
class StatsControllersTests: XCTestCase {

    func test_collectionViewNumberOfCells() {
        
        let sut = StatsController()
        sut.loadView()
        sut.viewModel = StatsControllerViewModelSpy()
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), sut.viewModel.orderedForms.count)
    }

    func test_collectionViewCellDequeuing() {
        let sut = StatsController()
        sut.loadView()
        sut.viewModel = StatsControllerViewModelSpy()
        
        if let cell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? StatCell {
            XCTAssertNotNil(cell.form)
        } else {
            XCTFail()
        }
        
    }
    
    func test_viewModelDelegateSet() {
        
        let sut = StatsController()
        sut.viewDidLoad()
        XCTAssertIdentical(sut.viewModel.delegate, sut)
        
    }
}

fileprivate class StatsControllerViewModelSpy: StatsControllerViewModel {
    
    override var orderedForms: [(form: Form, hits: Int)] {
        return Array(repeating: Form.new(), count: 10).map({($0,3)})
    }
    
}
