//
//  Form.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 31/08/2021.
//

import UIKit
/**
 The main object that is passed around controllers and viewModels.
 The model can be saved and retrieved from device memory with **FormsService**
 */
struct Form: Codable, Hashable {
    var int1: Int
    var int2: Int
    var limit: Int
    var string1: String
    var string2: String
}

extension Form {
    var name: String {
        return String(format: "%d • %d • %d • %@ • %@", arguments: [int1, int2, limit, string1, string2])
    }
    
    var fizzBuzz: String {
        return string1 + " " + string2
    }
    
    /**
     What the correct inputs should be given the form's parameters.
     It is an array of inputs. You can't transform it into a string using **getOutPutString(for: )**
     */
    var correctOuputs: [String] {
        var output = [String]()
        for i in 0...limit {
            if (i%int1 == 0 && i%int2 == 0) {
                output.append(string1+string2)
            } else if (i%int1 == 0) {
                output.append(string1)
            } else if (i%int2 == 0) {
                output.append(string2)
            } else {
                output.append("\(i)")
            }
        }
        return output
    }
    
    /**
     Parses and array of inputs into a string
     - Parameter inputs : An array of string inputs to be parsed
     - Returns: An attributed string which can latter be customized for UI highlithing
     */
    func getOutPutString(for inputs: [String]) -> NSAttributedString {
        var string = ""
        for i in inputs {
            if string == "" {
                string += i
            } else {
                string += " • " + i
            }
        }
        return NSAttributedString(string: string)
    }
    
    ///Returns a new **Form** with default params.
    static func new() -> Form {
        return .init(int1: 0, int2: 0, limit: 0, string1: "", string2: "")
    }
}
