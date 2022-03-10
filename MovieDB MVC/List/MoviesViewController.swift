//
//  ViewController.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 03/03/22.
//

import UIKit

class MoviesViewController: UITableViewController, UISearchResultsUpdating, Storyboarded {
    var coordinator: Coordinator?
    let movieAPI = MovieAPI()
    let searchController = UISearchController()
    
    enum MovieListType: CaseIterable {
        case popularHeader, popular, playingHeader, playing
    }
    
    let sections = MovieListType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Movies"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.view.addSubview(refreshControl!)
        
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
        if searchController.isActive {
            return 1
        } else {
            return sections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        
        if searchController.isActive {
            return movieAPI.searchMovie.count
            
        } else {
            
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
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[indexPath.section]
        
        if searchController.isActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
            let movie = movieAPI.searchMovie[indexPath.row]
            cell.movie = movie
            cell.reload()
            return cell
            
        } else {
            
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
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        
        if searchController.isActive {
            coordinator?.showDetails(of: movieAPI.searchMovie[indexPath.row], api: movieAPI)
        } else {
            switch section {
            case .popular:
                coordinator?.showDetails(of: movieAPI.popularMovies[indexPath.row], api: movieAPI)
            case .playing:
                coordinator?.showDetails(of: movieAPI.nowPlayingMovies[indexPath.row], api: movieAPI)
            default:
                return
            }
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 10 {
            movieAPI.requestNowPlayingMovies {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else { return }
        
        print(searchString)
        print("Ative: ", searchController.isActive, "Array search movies: ", movieAPI.searchMovie)
        
        movieAPI.searchMovie(searchText: searchString) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    //MARK: Objc Refresh
    @objc func refresh() {
        movieAPI.reload {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        refreshControl?.endRefreshing()
    }
}

