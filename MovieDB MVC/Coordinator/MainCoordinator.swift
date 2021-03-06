//
//  AppCoordinator.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 04/03/22.
//

import UIKit

/// The coordinator responsable for the navigation in this app.
class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MoviesViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetails(of movie: Movie, api: MovieAPI) {
        let vc = DetailsViewController.instantiate()
        vc.movie = movie
        vc.genresText = api.getGeneresText(of: movie)
        navigationController.pushViewController(vc, animated: true)
    }
}
