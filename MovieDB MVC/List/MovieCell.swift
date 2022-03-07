//
//  MovieCell.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 05/03/22.
//

import UIKit

class MovieCell: UITableViewCell {
    static var identifier: String = "MovieCell"
    var movie: Movie?
    
    @IBOutlet private weak var poster: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var overview: UILabel!
    @IBOutlet private weak var rating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        poster.layer.cornerRadius = 10
    }

    /// Reload the movie cell content with the data into the movie varivable.
    func reload() {
        poster.imageFromServerURL("https://image.tmdb.org/t/p/w200\(movie!.posterPath)", placeHolder: UIImage())
        title.text = movie?.title
        overview.text = movie?.overview
        rating.text = "\(movie?.voteAverage ?? 0)"
    }
}
