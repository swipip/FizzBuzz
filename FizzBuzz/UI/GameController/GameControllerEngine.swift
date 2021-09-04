//
//  GameControllerEngine.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 01/09/2021.
//

import Foundation

protocol GameControllerEngineDelegate: AnyObject {
    ///Called every time a new number should get displayed on screen.
    func engine(displayNewLabel label: String)
    ///Called when user made a mistake. Namely tapped the wrong button.
    func userDidFail(score: Int)
    ///Called when user did make a correct move.
    func userDidSucceed(message: String, score: Int)
    ///Called when gamed finishes.
    func engine(gameEnded finalScore: Int, outputString: NSAttributedString)
    ///Called when gamed is saved. After the game ended.
    func gameSaved()
}
class GameControllerEngine {
    
    weak var delegate: GameControllerEngineDelegate?
    
    private (set) var form: Form
    
    init(form: Form) {
        self.form = form
    }
    
    private (set) var score = 0
    private var current = 0
    private var gameDispatchWork: DispatchWorkItem?
    private var speed: TimeInterval = 1
    private var userInputs = [String]()
    private var lastMove: String?
    
    func startGame() {
        gameDispatchWork = .init()
        {
            [weak self] in self?.gameBlockHandler()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + max(0.2,speed), execute: gameDispatchWork!)
        
    }
    
    /**
     Notify viewModel client that the game has ended ans save the form to the database.
     */
    func endGame() {
        delegate?.engine(
            gameEnded: score,
            outputString: form.getOutPutString(for: form.correctOuputs))
        saveGame()
    }
    
    /**
     Gets called on timely basis along the game.
     It sets the current number, appends user inputs, increases speed as time passes and checks whether the game should carry on or not based on the limit set in the form
     */
    func gameBlockHandler() {
        current += 1
        userInputs.append(lastMove ?? "\(current)")
        lastMove = nil
        speed *= 0.99
        if current <= form.limit {
            delegate?.engine(displayNewLabel: "\(current)")
            startGame()
        } else {
            endGame()
        }
    }
    
    ///Checks whether the current displayed nummber is dividable by int1 from the form
    func checkFizz() {
        lastMove = form.string1
        if (current % form.int1 == 0) {
            score += 2
            delegate?.userDidSucceed(message: form.string1, score: score)
            return
        }
        score -= 1
        delegate?.userDidFail(score: score)
    }
    
    ///Checks whether the current displayed nummber is dividable by int2 from the form
    func checkBuzz() {
        lastMove = form.string2
        if (current % form.int2 == 0) {
            score += 2
            delegate?.userDidSucceed(message: form.string2, score: score)
            return
        }
        score -= 1
        delegate?.userDidFail(score: score)
    }
    
    ///Checks whether the current displayed nummber is dividable by both int1 and int2 from the form
    func checkFizzBuzz() {
        lastMove = form.string1 + form.string2
        if ((current % form.int2 == 0) && (current % form.int1 == 0)) {
            score += 2
            delegate?.userDidSucceed(message: form.fizzBuzz, score: score)
            return
        }
        score -= 1
        delegate?.userDidFail(score: score)
    }
    
    func saveGame() {
        
        FormsService.shared.save(form) { [weak delegate] success in
            if !success {
                Logger.shared.logError(message: "Game couldn't be saved an error occured")
            } else {
                Logger.shared.logInfo(message: "Game saved")
                delegate?.gameSaved()
            }
        }
        
    }
}
