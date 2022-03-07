//
//  ViewController.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 03/03/22.
//

import UIKit

class MoviesViewController: UITableViewController, Storyboarded {
    var coordinator: Coordinator?
    var movies: [Movie] = []
    var posters: [Int: UIImage] = [:]
    let movieAPI = MovieAPI()
    
    enum MovieListType: CaseIterable {
        case popularHeader, popular, playingHeader, playing
    }
    
    let sections = MovieListType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Movies"
        
        movieAPI.requestMovies { movies in
            self.movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        
        switch currentSection { // FIXME: change hardcoded numbers in .popular & .playing when service is implemented.
        case .popularHeader:
            return 1
        case .popular:
            return movies.count
        case .playingHeader:
            return 1
        case .playing:
            return movies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[indexPath.section]
        
        switch currentSection {
        case .popularHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.identifier, for: indexPath) as! HeaderCell
            cell.title = "Popular Movies"
            cell.reload()
            return cell
        case .playingHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.identifier, for: indexPath) as! HeaderCell
            cell.title = "Now Playing"
            cell.reload()
            return cell
        case .playing, .popular:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
            
            let movie = movies[indexPath.row]
            cell.movie = movie
            cell.reload()
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (coordinator as? MainCoordinator)?.showDetails()
    }
}

