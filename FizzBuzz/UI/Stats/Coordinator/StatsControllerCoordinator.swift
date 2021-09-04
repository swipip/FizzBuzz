//
//  Coordinator.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 02/09/2021.
//

import UIKit

protocol StatsControllerCoordinatorDelegate: Coordinator {
    var parentCoordinator: TabBarCoordinatorDelegate? { get }
    func play(_ form: Form)
}
class StatsControllerCoordinator: StatsControllerCoordinatorDelegate {

    var parentCoordinator: TabBarCoordinatorDelegate?
    var rootController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let vc = StatsController()
        vc.coordinator = self
        rootController = vc.embedInNav()
        return rootController
    }
    
    func play(_ form: Form) {
        parentCoordinator?.flow(to: .form)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.parentCoordinator?.formCoordinator.play(form)
        }
    }
    
}
