//
//  Coordinator.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 04/03/22.
//

import UIKit

/// Protocol responsable for managing navigation of the view controllers in the app.
protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    /// Starts the navigation wich this coordinator is responsable.
    func start()
    
    /// Open a view with details of a movie.
    /// - Parameters:
    ///     - of: movie wich details will be displayed.
    ///     - api: the app data source.
    func showDetails(of movie: Movie, api: MovieAPI)
}
