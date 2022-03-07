//
//  ModelMovie.swift
//  MovieDB MVC
//
//  Created by Rodrigo de Anhaia on 04/03/22.
//

import UIKit

struct Movie: CustomStringConvertible {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let voteAverage: Double
    let releaseDate: String
    
    var description: String {
        return "\(title) is a(n) \(overview) with \(id) ID"
    }
    
    var image: UIImage {
        let urlString = "https://image.tmdb.org/t/p/w200\(posterPath)"
        
        guard let url = URL(string: urlString) else { return UIImage(named: "sample")! }
        guard let data = try? Data(contentsOf: url) else { return UIImage(named: "sample")! }
        guard let image = UIImage(data: data) else { return UIImage(named: "sample")! }
        
        return image
    }
}
