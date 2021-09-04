//
//  GameControllerTests.swift
//  FizzBuzzTests
//
//  Created by Gautier Billard on 01/09/2021.
//

import XCTest

@testable import FizzBuzz
class GameControllerTests: XCTestCase {

    var form: Form!
    
    override func setUp() {
        super.setUp()
        form = Form(int1: 1, int2: 2, limit: 3, string1: "test", string2: "test")
    }
    
    func test_mainLabelUpdate() {
        
        let sut = GameController(form: form)
        sut.loadView()
        
        let testString = "update"
        
        sut.engine(displayNewLabel: testString)
        
        XCTAssertEqual(sut.mainLabel.text, testString)
        
    }
    
    func test_scoreUpdateOnFail() {
        let sut = GameController(form: form)
        sut.loadView()
        
        let testScore = 10
        
        sut.userDidFail(score: testScore)
        
        XCTAssertEqual(sut.score.text, "\(testScore)")
    }
    func test_scoreUpdateOnSuccess() {
        let sut = GameController(form: form)
        sut.loadView()
        
        let testScore = 10
        
        sut.userDidSucceed(message: "", score: testScore)
        
        XCTAssertEqual(sut.score.text, "\(testScore)")
    }

    func test_buttonsUpdate() {
        let sut = GameController(form: form)
        sut.loadView()
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.fizz.title(for: .normal), form.string1)
        XCTAssertEqual(sut.buzz.title(for: .normal), form.string2)
        
    }
    
    func test_gameEndedFinalString() {
        let sut = GameController(form: form)
        sut.loadView()
        
        sut.engine(gameEnded: 10, outputString: NSAttributedString(string: ""))
        
        XCTAssertEqual("Fini !", sut.mainLabel.text)
    }
    
    func test_testCountDownLaunch() {
        let sut = GameControllerSpy(form: form)
        sut.viewDidAppear(false)
        XCTAssertTrue(sut.countDownStarted)
    }
    
    func test_animateWrongCalled() {
        let sut = GameControllerSpy(form: form)
        let score = 10
        sut.loadView()
        sut.userDidFail(score: score)
        XCTAssertTrue(sut.didCallAnimateWrong)
        XCTAssertEqual(sut.score.text, "\(score)")
    }
    
    func test_animateCorrectCalled() {
        let sut = GameControllerSpy(form: form)
        let score = 10
        sut.loadView()
        sut.userDidSucceed(message: "", score: score)
        XCTAssertTrue(sut.didCallAnimateCorrect)
        XCTAssertEqual(sut.score.text, "\(score)")
    }
    
    func test_fizzCheckCall() {
        let sut = GameController(form: form)
        let spy = GameControllerEngineSpy(form: form)
        sut.engine = spy
        
        sut.fizzButtonPressed(UIButton())
        
        XCTAssertTrue(spy.didCheckFizz)
    }
    func test_buzzCheckCall() {
        let sut = GameController(form: form)
        let spy = GameControllerEngineSpy(form: form)
        sut.engine = spy
        
        sut.buzzButtonPressed(UIButton())
        
        XCTAssertTrue(spy.didCheckBuzz)
    }
    func test_fizzBuzzCheckCall() {
        let sut = GameController(form: form)
        let spy = GameControllerEngineSpy(form: form)
        sut.engine = spy
        
        sut.tapHandler()
        
        XCTAssertTrue(spy.didCheckFizzBuzz)
    }
}

fileprivate class GameControllerSpy: GameController {
    var countDownStarted = false
    var didCallAnimateCorrect = false
    var didCallAnimateWrong = false
    
    override func startCountDown() {
        countDownStarted = true
    }
    
    override func animateWrong() {
        didCallAnimateWrong = true
    }
    override func animateCorrect() {
        didCallAnimateCorrect = true
    }
}
fileprivate class GameControllerEngineSpy: GameControllerEngine {
    var didCheckFizz = false
    var didCheckBuzz = false
    var didCheckFizzBuzz = false
    
    override func checkFizz() {
        didCheckFizz = true
    }
    
    override func checkBuzz() {
        didCheckBuzz = true
    }
    
    override func checkFizzBuzz() {
        didCheckFizzBuzz = true
    }
    
}
