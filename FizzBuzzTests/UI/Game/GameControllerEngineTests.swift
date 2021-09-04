//
//  GameControllerEngineTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 01/09/2021.
//

import XCTest

@testable import FizzBuzz
class GameControllerEngineTests: XCTestCase {
    
    var form = Form(int1: 2, int2: 5, limit: 100, string1: "a", string2: "z")
    
    override func setUp() {
        super.setUp()
        
        let userDefault = UserDefaults(suiteName: #file)
        userDefault?.removePersistentDomain(forName: #file)
        
        FormsService.shared = FormsService(userDefault!)
        
    }
    
    func test_currentIncrement() {
        
        let sut = GameControllerEngine(form: form)
        
        let spy = GameControllerEngineDelegateSpy()
        sut.delegate = spy
        
        for i in 1...120 {
            sut.gameBlockHandler()
            if i <= form.limit {
                XCTAssertEqual(spy.currentLabel, "\(i)")
            } else {
                XCTAssertTrue(spy.gamedEnded)
            }
        }
        
    }
    
    func test_GameSaveCall() {
        let sut = GameControllerEngine(form: form)
        
        let spy = GameControllerEngineDelegateSpy()
        sut.delegate = spy
        
        let exp = expectation(description: "wait for game saved")
        
        sut.endGame()
        
        spy.saved = {
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error)
        }
    }
    
    func test_checkFizz() {
        
        let sut = GameControllerEngine(form: form)
        
        let spy = GameControllerEngineDelegateSpy()
        sut.delegate = spy
        
        for i in 1...form.limit {
            sut.gameBlockHandler()
            sut.checkFizz()
            if i % form.int1 == 0 {
                XCTAssertFalse(spy.error)
            } else {
                XCTAssertTrue(spy.error)
            }
        }
    }
    
    func test_checkBuzz() {
        
        let sut = GameControllerEngine(form: form)
        
        let spy = GameControllerEngineDelegateSpy()
        sut.delegate = spy
        
        for i in 1...form.limit {
            sut.gameBlockHandler()
            sut.checkBuzz()
            if i % form.int2 == 0 {
                XCTAssertFalse(spy.error)
            } else {
                XCTAssertTrue(spy.error)
            }
        }
    }
    
    func test_checkFizzBuzz() {
        form.int2 = 5
        form.int1 = 3
    
        let sut = GameControllerEngine(form: form)
        
        let spy = GameControllerEngineDelegateSpy()
        sut.delegate = spy
        
        for i in 1...form.limit {
            sut.gameBlockHandler()
            sut.checkFizzBuzz()
            if (i % form.int2 == 0) && (i % form.int1 == 0) {
                XCTAssertFalse(spy.error)
            } else {
                XCTAssertTrue(spy.error)
            }
        }
    }
    
    func test_HandlerCall() {
        let sut = EngineSpy(form: form)
        
        let expectation = self.expectation(description: "Wait for handler call")
        
        sut.didCallBlock = {
            expectation.fulfill()
        }

        sut.startGame()
        
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func test_saveFormCall() {
        let sut = EngineSpy(form: form)
        
        let expectation = self.expectation(description: "Wait for save call upon game end")
        
        sut.didCallSave = {
            expectation.fulfill()
        }

        sut.endGame()
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }
    
    func test_outPutString() {
//        let sut = GameControllerEngine(form: .init(int1: 1, int2: 2, limit: 10, string1: "a", string2: "z"))
//        let spy = GameControllerEngineDelegateSpy()
//        
//        sut.delegate = spy
//        sut.gameBlockHandler()
//        sut.checkBuzz()
//        sut.gameBlockHandler()
//        sut.checkFizz()
//        sut.gameBlockHandler()
//        sut.checkFizz()
//        sut.gameBlockHandler()
//        sut.gameBlockHandler()
//        sut.gameBlockHandler()
//        sut.gameBlockHandler()
//        sut.gameBlockHandler()
//        sut.gameBlockHandler()
//        
//        sut.endGame()
//        
//        XCTAssertEqual(spy.outputString, "1 • z • a • a • 5 • 6 • 7 • 8 • 9")
    }
    
}
fileprivate class GameControllerEngineDelegateSpy: GameControllerEngineDelegate {
    
    var currentLabel: String = ""
    var gamedEnded = false
    var error = false
    var saved: (() -> Void)?
    var outputString: String?
    
    func engine(displayNewLabel label: String) {
        currentLabel = label
    }
    
    func engine(gameEnded finalScore: Int, outputString: NSAttributedString) {
        gamedEnded = true
        self.outputString = outputString.string
    }
    
    func userDidFail(score: Int) {
        error = true
    }
    
    func userDidSucceed(message: String, score: Int) {
        error = false
    }
    
    func gameSaved() {
        saved?()
    }
}

fileprivate class EngineSpy: GameControllerEngine {
    var didCallBlock:(()->())?
    var didCallSave:(()->())?
    
    override func gameBlockHandler() {
        didCallBlock?()
    }
    
    override func saveGame() {
        didCallSave?()
    }
}
