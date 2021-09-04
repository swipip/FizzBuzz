//
//  GameController.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 01/09/2021.
//

import UIKit

class GameController: UIViewController {
    
    // MARK: UI elements 􀯱
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var fizz: UIButton!
    @IBOutlet weak var buzz: UIButton!
    @IBOutlet weak var outputString: UILabel!
    
    // MARK: Data Management 􀤃
    
    var engine: GameControllerEngine
    
    // MARK: View life cycle 􀐰
    
    init(form: Form) {
        engine = GameControllerEngine(form: form)
        super.init(nibName: "GameController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine.delegate = self
        
        view.backgroundColor = .fbBlue
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        )
    
        fizz.setTitle(engine.form.string1, for: .normal)
        buzz.setTitle(engine.form.string2, for: .normal)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCountDown()
    }
    // MARK: Animations 􀢅
    
    ///Colors breifly the view in red to notify user of a wrong input
    func animateWrong() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction]) {
            self.view.backgroundColor = .fbRed
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction]) {
                self.view.backgroundColor = .fbBlue
            }
        }
    }
    
    ///Colors breifly the view in green to notify user of a correct input
    func animateCorrect() {
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = .fbGreen
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.view.backgroundColor = .fbBlue
            }
        }
    }
    // MARK: Interactions 􀛹
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func fizzButtonPressed(_ sender: UIButton) {
        engine.checkFizz()
    }
    @IBAction func buzzButtonPressed(_ sender: UIButton) {
        engine.checkBuzz()
    }
    @objc func tapHandler(){
        engine.checkFizzBuzz()
    }
    
    ///Runs a count down from 3 to 0 to let know the user the game is about to start
    func startCountDown() {
        hintLabel.text = "Attention ça va commencer dans"
        var countDown = 3
        func handler(_ timer: Timer) {
            countDown -= 1
            mainLabel.text = "\(countDown)"
            if countDown == 0 {
                timer.invalidate()
                hintLabel.isHidden = true
                engine.startGame()
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: handler(_:))
    }
    
}
extension GameController: GameControllerEngineDelegate {
    func engine(gameEnded finalScore: Int, outputString: NSAttributedString) {
        mainLabel.text = "Fini !"
        finishButton.isHidden = false
        self.outputString.isHidden = false
        self.outputString.attributedText = outputString
    }
    
    func gameSaved() {}
    
    func engine(displayNewLabel label: String) {
        mainLabel.text = label
    }
    
    func userDidFail(score: Int) {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        self.score.text = "\(score)"
        animateWrong()
    }
    
    func userDidSucceed(message: String, score: Int) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        self.score.text = "\(score)"
        animateCorrect()
    }
    
}
