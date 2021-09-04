//
//  FormInstruction.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 31/08/2021.
//

import UIKit

enum Instruction: CaseIterable {
    
    case firstInt, secondInt, limit, firstString, secondString
    
    var instructions: FormInstruction {
        switch self {
        case .firstInt:
            return .init(buttonType: .next, title: "Premier nombre", description: "Choisi un premier nombre pour jouer", type: .firstInt, keyBoardType: .numberPad)
        case .secondInt:
            return .init(buttonType: .next, title: "Deuxième nombre", description: "Choisi un deuxième nombre pour jouer", type: .firstInt, keyBoardType: .numberPad)
        case .limit:
            return .init(buttonType: .next, title: "Nombre limite", description: "Choisi un nombre limite de tours", type: .firstInt, keyBoardType: .numberPad)
        case .firstString:
            return .init(buttonType: .next, title: "Première expression", description: "Choisi une première expression pour jouer", type: .firstInt, keyBoardType: .default)
        case .secondString:
            return .init(buttonType: .go, title: "Deuxième expression", description: "Choisi une deuxième expression pour jouer", type: .firstInt, keyBoardType: .default)
        }
    }
}
struct FormInstruction: Hashable {
    var buttonType: ButtonType
    var title: String
    var description: String
    var type: Instruction
    var keyBoardType: UIKeyboardType
    
    private (set) var value: String = ""
}
extension FormInstruction {
    
    /**
     Set the value parameter of the form.
     - Parameter value: The value to be set
     - Throws: Throws and error is the value is not castable to an Int when the type requests an Int
     */
    mutating func setValue(_ value: String) throws {
        if  type == .firstInt || type == .secondInt || type == .limit {
            if let intValue = Int(value), intValue != 0 {
                self.value = value
            } else {
                throw NSError(domain: "The expected type for this instruction is not correct", code: 1, userInfo: [:])
            }
        } else {
            self.value = value
        }
    }
    
    init(_ type: Instruction) {
        title = type.instructions.title
        description = type.instructions.description
        keyBoardType = type.instructions.keyBoardType
        buttonType = type.instructions.buttonType
        self.type = type
    }
    
    fileprivate init(
        buttonType: ButtonType, title: String, description: String, type: Instruction, keyBoardType: UIKeyboardType) {
        self.buttonType = buttonType
        self.title = title
        self.description = description
        self.type = type
        self.keyBoardType = keyBoardType
    }
    
    enum ButtonType: String {
        case next = "NEXT"
        case go = "GO !"
    }
}
