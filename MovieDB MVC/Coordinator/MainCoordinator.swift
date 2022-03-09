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
    
    /// Open a view with details of a movie.
    /// - Parameters:
    ///     - of: movie wich details will be displayed.
    ///     - api: the app data source.
    func showDetails(of movie: Movie, api: MovieAPI) {
        let vc = DetailsViewController.instantiate()
        vc.coordinator = self
        vc.movie = movie
        vc.genresText = api.getGeneresText(of: movie)
        navigationController.pushViewController(vc, animated: true)
    }
}
