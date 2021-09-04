//
//  AppCoordinator.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 02/09/2021.
//

import UIKit

enum AppFlow {
    case form
    case stats
}
protocol TabBarCoordinatorDelegate {
    var formCoordinator: FormCoordinatorDelegate { get set }
    func flow(to: AppFlow)
}
class AppCoordinator: Coordinator, TabBarCoordinatorDelegate {

    var coordinator: Coordinator?
    var rootController: UIViewController = TabBarController()
    
    var formCoordinator: FormCoordinatorDelegate = FormCoordinator()
    var statsCoordinator = StatsControllerCoordinator()
    
    func start() -> UIViewController {
        
        let formController = formCoordinator.start()
        formController.tabBarItem = UITabBarItem(
            title: "",
            image:K.images.gamePad,
            selectedImage: K.images.gamePadFill)
        
        formCoordinator.parentCoordinator = self
        
        let statsController = statsCoordinator.start()
        statsController.tabBarItem = UITabBarItem(
            title: "",
            image: K.images.chart,
            selectedImage: K.images.chart)
        
        statsCoordinator.parentCoordinator = self
        
        if let controller = rootController as? TabBarController {
            controller.viewControllers = [formController, statsController]
            controller.setUp()
        }
        
        return rootController
    }
    
    /**
        tells the coordinator to switch to a designated controller
        - Parameter flow: The location in the tab bar
     */
    func flow(to flow: AppFlow) {
        guard let tabbarController = (rootController as? TabBarController) else {
            fatalError("Tab bar controller is not set")
        }
        switch flow {
        case .form:
            tabbarController.selectedIndex = 0
            tabbarController.tabBarController(tabbarController, didSelect: formCoordinator.rootController)
        case .stats:
            tabbarController.selectedIndex = 1
            tabbarController.tabBarController(tabbarController, didSelect: formCoordinator.rootController)
        }
    }
    
}
