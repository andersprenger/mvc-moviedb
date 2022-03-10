//
//  MovieParser.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 09/03/22.
//

import Foundation

struct MovieParser {
    typealias JSON = [String: Any]
    
    static func parseMovie(from json: JSON) -> Movie? {
        guard let id = json["id"] as? Int,
              let title = json["title"] as? String,
              let overview = json["overview"] as? String,
              let posterPath = json["poster_path"] as? String,
              let voteAverage = json["vote_average"] as? Double,
              let releaseDate = json["release_date"] as? String,
              let genres = json["genre_ids"] as? [Int]
        else { return nil }
        
        return Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            genres: genres,
            voteAverage: voteAverage,
            releaseDate: releaseDate)
    }
}
