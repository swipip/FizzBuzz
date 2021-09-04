//
//  FormCell.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 31/08/2021.
//

import UIKit

protocol FormCellDelegate: AnyObject {
    func formCell(didUpdateTextField instruction: FormInstruction?, isValueValid: Bool)
    func didPressNextButton(cell: FormCell)
}
class FormCell: UICollectionViewCell, Reusable {
    static var reuseId = "FormCell"
    
    weak var delegate: FormCellDelegate?
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.adjustsFontSizeToFitWidth = true
            textField.minimumFontSize = 65
            textField.delegate = self
        }
    }
    
    var isTextFieldValueValid = false
    
    private (set) var instruction: FormInstruction?

    func setInstruction(_ instruction: FormInstruction?) {
        self.instruction = instruction
        nextButton.setTitle(instruction?.buttonType.rawValue, for: .normal)
        textField.keyboardType = instruction?.keyBoardType ?? .default
        titleLabel.text = instruction?.title
        descriptionLabel.text = instruction?.description
        textField.text = instruction?.value
        isTextFieldValueValid = validateTextField(instruction?.value)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        highlightView.backgroundColor = .fbBlue
        textField.text = ""
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if isTextFieldValueValid {
            delegate?.didPressNextButton(cell: self)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            animateWrong()
        }
    }
    
    func animateWrong() {
        UIView.animate(withDuration: 0.2) {
            self.highlightView.backgroundColor = .fbRed
        }
    }
    func animateCorrect() {
        UIView.animate(withDuration: 0.2) {
            self.highlightView.backgroundColor = .fbBlue
        }
    }
}

extension FormCell: UITextFieldDelegate {
    
    func validateTextField(_ text: String?) -> Bool {
        if let text = text, text != "",
           let type = instruction?.type {
            
            switch type  {
            case .firstInt, .secondInt, .limit:
                if let value = Int(text), value != 0 {
                    return true
                }
            case .firstString, .secondString:
                return true
            }
            
        }
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let text = textField.text
        
        isTextFieldValueValid = validateTextField(text)
        
        if isTextFieldValueValid {
            animateCorrect()
            try? instruction?.setValue(text!)
        } else {
            animateWrong()
        }
        
        delegate?.formCell(
            didUpdateTextField: instruction,
            isValueValid: isTextFieldValueValid)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
