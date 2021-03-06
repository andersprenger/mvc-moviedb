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
    let genres: [Int]
    let voteAverage: Double
    let releaseDate: String
    
    var description: String {
        return "\(title) is a(n) \(overview) with \(id) ID"
    }
}
