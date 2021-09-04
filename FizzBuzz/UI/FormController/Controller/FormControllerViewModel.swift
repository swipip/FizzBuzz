//
//  FormControllerViewModel.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 31/08/2021.
//

import Foundation

protocol FormControllerViewModelDelegate: AnyObject {
    /**
     Called upon form validation failure. Provides the index at which the error lies.
     - Parameter index: The index where the error lies.
     */
    func formControllerViewModel(didFindMissingValueAtIndex index: Int)
}
class FormControllerViewModel {
    
    weak var delegate: FormControllerViewModelDelegate?
    
    var instructions: [FormInstruction] =
        [
            .init(.firstInt),
            .init(.secondInt),
            .init(.limit),
            .init(.firstString),
            .init(.secondString)
        ]
    
    private (set) var form: Form = Form.new()
    
    /**
     Updates the instructions array with an update instruction.
     - Parameter instruction: Pass the instruction you need to update
     
     Use this method when you have an instruction with an updated value for instance and you want the model to take the change into account.
     The Method will compare existing instructions, remove the old one and put the new in place.
     */
    func updateInstruction(_ instruction: FormInstruction) {
        guard let index = instructions.firstIndex(where: {instruction.type == $0.type}) else {
            fatalError()
        }
        instructions.removeAll(where: {instruction.type == $0.type})
        instructions.insert(instruction, at: index)
        assert(instructions.count == 5)
    }
    
    ///Ultimate form validation check before use. Checks for any missing value in the form but not for type compliance.
    func checkFormIsValid() -> Bool {
        for (i, instruction) in instructions.enumerated() {
            if instruction.value == "" {
                delegate?.formControllerViewModel(didFindMissingValueAtIndex: i)
                return false
            }
        }
        return true
    }
    /**
     Updates the current form with the value set in the instruction
     - Parameter intruction: The instrcution object with the value to update the form with
     */
    func updateForm(_ instruction: FormInstruction) {
        switch instruction.type {
        case .firstInt:
            form.int1 = Int(instruction.value)!
        case .secondInt:
            form.int2 = Int(instruction.value)!
        case .limit:
            form.limit = Int(instruction.value)!
        case .firstString:
            form.string1 = instruction.value
        case .secondString:
            form.string2 = instruction.value
        }
    }
    
    ///Reset the form to default values as well as the instructions passed in the cells
    func resetForm() {
        instructions = [
            .init(.firstInt),
            .init(.secondInt),
            .init(.limit),
            .init(.firstString),
            .init(.secondString)
        ]
        form = Form.new()
    }
    
}
