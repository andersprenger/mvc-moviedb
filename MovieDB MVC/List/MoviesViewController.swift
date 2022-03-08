//
//  ViewController.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 03/03/22.
//

import UIKit

class MoviesViewController: UITableViewController, UISearchResultsUpdating, Storyboarded {
    var coordinator: MainCoordinator?
    let movieAPI = MovieAPI()
    
    enum MovieListType: CaseIterable {
        case popularHeader, popular, playingHeader, playing
    }
    
    let sections = MovieListType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Movies"
        self.navigationItem.searchController = UISearchController()
        
        movieAPI.requestPopularMovies {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        movieAPI.requestNowPlayingMovies {
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
        
        switch currentSection {
        case .popularHeader:
            return 1
        case .popular:
            return movieAPI.popularMovies.count < 3 ? movieAPI.popularMovies.count : 3
        case .playingHeader:
            return 1
        case .playing:
            return movieAPI.nowPlayingMovies.count
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
        case .playing:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
            let movie = movieAPI.nowPlayingMovies[indexPath.row]
            cell.movie = movie
            cell.reload()
            return cell
        case .popular:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
            let movie = movieAPI.popularMovies[indexPath.row]
            cell.movie = movie
            cell.reload()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showDetails(of: movieAPI.popularMovies[indexPath.row], api: movieAPI)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 10 {
            // TODO: paginação aqui...
            print("manda mais")
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else { return }

        print(searchString)
        
        // TODO: pesquisa...
    }
}

