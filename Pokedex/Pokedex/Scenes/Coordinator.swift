//
//  Coordinator.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ViewController()
        navigationController.pushViewController(viewController, animated: false)
    }
}
