//
//  FormControllerCoordinator.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 02/09/2021.
//

import UIKit

protocol FormCoordinatorDelegate: Coordinator {
    var parentCoordinator: TabBarCoordinatorDelegate? { get set }
    func play(_ form: Form)
}
class FormCoordinator: FormCoordinatorDelegate {
    
    var parentCoordinator: TabBarCoordinatorDelegate?
    var rootController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let vc = FormController()
        vc.coordinator = self
        rootController = vc.embedInNav()
        return rootController
    }
    
    func play(_ form: Form) {
        let vc = GameController(form: form)
        navigationController?.visibleViewController?.present(vc, animated: true, completion: nil)
    }
}
