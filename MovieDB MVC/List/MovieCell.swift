//
//  MovieCell.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 05/03/22.
//

import UIKit

class MovieCell: UITableViewCell {
//    var movie: Movie?
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        poster.layer.cornerRadius = 10
    }

//    func reload() {
//        poster.image = movie.image
//        title.text = movie.title
//        overview.text = movie.overview
//        rating.text = movie.rating
//    }
}
