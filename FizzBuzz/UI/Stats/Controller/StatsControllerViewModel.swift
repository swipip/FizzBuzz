//
//  StatsControllerViewModel.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 01/09/2021.
//

import Foundation

protocol StatsControllerViewModelDelegate: AnyObject {
    func statsControllerViewModel(didLoadForms forms: [Form])
    ///Called when ordered forms are ready. From top to least.
    func statsControllerViewModel(didLoadOrdered forms: [(form: Form, hits: Int)])
}
class StatsControllerViewModel {
    
    weak var delegate: StatsControllerViewModelDelegate?
    
    private (set) var forms: [Form] = []
    private (set) var orderedForms: [(form: Form, hits: Int)] = []
    
    var maxHits: Int {
        return orderedForms.map({$0.1}).max() ?? 1
    }
    /**
     Retrieves allready played forms
     */
    func getForms() {
        FormsService.shared.getForms { [weak self] result in
            switch result {
            case .success(let forms):
                self?.forms = forms
                self?.delegate?.statsControllerViewModel(didLoadForms: forms)
            case .failure(let err):
                Logger.shared.logError(
                    message: "Forms could not be loaded an error occured. \(err.localizedDescription)")
            }
        }
    }
    
    /**
     Get top played forms. Later notify through a delegate call later.
     */
    func getTopForms() {
        
        var ranking = [Form: Int]()
        
        for form in forms {
            ranking[form] = (ranking[form] ?? 0) + 1
        }
        
        let orderedRank = ranking.sorted(by: {$0.1 > $1.1}).map({(form: $0.0, hits: $0.1)})
        
        self.orderedForms = orderedRank
        delegate?.statsControllerViewModel(didLoadOrdered: orderedForms)
    }
    
}

