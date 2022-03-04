//
//  Coordinator.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 04/03/22.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    /// Starts the navigation wich this coordinator is responsable.
    func start()
}
