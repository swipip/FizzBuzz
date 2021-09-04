//
//  FormsService.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 01/09/2021.
//

import Foundation
/**
 The service responsible for saveing and retrieving forms from the database.
 */
struct FormsService {
    
    private (set) var userDefaults: UserDefaults
    
    /**
     The default instance to use in most cases. You can also provide your own instance to be used project wide.
     */
    static var shared = FormsService(UserDefaults.standard)
    
    init(_ userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    private var key = "com.fizzbuzz.gautierbillard"
    
    /**
     Saves a **form** object into the database. Method is async and calls a completion handler completion.
     
     - Parameter form: The form to save
     - Parameter completion: The completion block called when the save is complete
     - Parameter success: Whether the saving process was successful or not.
     
     Faillure occurs either when existing forms could not be decoded or when passed form can't be encoded
     */
    func save(_ form: Form, _ completion: @escaping (_ success: Bool)->()) {
        getForms { result in
            
            switch result {
            case .success(var forms):
                forms.append(form)
                do {
                    let data = try JSONEncoder().encode(forms)
                    userDefaults.setValue(data, forKey: key)
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure(_):
                completion(true)
            }
        }
    }
    /**
     Retrives forms from the database.
     
     - Parameter completion: The completion block called when the save is complete
     - Parameter result: A **result** object containing either an array of forms or an error
     
     Faillure occurs when existing forms can't be decoded
     */
    func getForms(_ completion: @escaping(_ result: Result<[Form],Error>) -> ()) {
        let queue = DispatchQueue(
            label: "decoding forms",
            qos: .userInitiated,
            attributes: .concurrent)
        
        queue.async {
            if let data = userDefaults.data(forKey: key) {
                do {
                    let forms = try JSONDecoder().decode([Form].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(forms))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.success([]))
                }
            }
        }
    }
    
}
