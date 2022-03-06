//
//  DetailsViewController.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 04/03/22.
//

import UIKit

class DetailsViewController: UIViewController, Storyboarded {
    var coordinator: Coordinator?
    
//    var movie: Movie?
    
    @IBOutlet private weak var poster: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var genres: UILabel!
    @IBOutlet private weak var overview: UILabel!
    @IBOutlet private weak var rating: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        poster.layer.cornerRadius = 10
        self.title = "Details"
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
//    func reload() {
//        poster.image = movie.image
//        movieTitle.text = movie.title
//        genres.text = movie.genres
//        overview.text = movie.overview
//        rating.text = movie.rating
//    }
}
