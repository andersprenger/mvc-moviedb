//
//  ViewController.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 03/03/22.
//

import UIKit

class ViewController: UIViewController {
    var movie: [Movie] = []
    let movieAPI = MovieAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieAPI.requestMovies { movies in
            self.movie = movies
            
          
        }
    }


}

