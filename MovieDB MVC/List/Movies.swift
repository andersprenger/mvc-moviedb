//
//  ViewController.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 03/03/22.
//

import UIKit

class Movies: UITableViewController, Storyboarded {
    var coordinator: Coordinator?
    
    enum MovieListType: CaseIterable {
        case popularHeader, popular, playingHeader, playing
    }
    
    let sections = MovieListType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator?.navigationController.navigationBar.prefersLargeTitles = true
        self.title = "Movies"
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
            return 3
        case .playingHeader:
            return 1
        case .playing:
            return 10
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
            return tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        }
    }
}

