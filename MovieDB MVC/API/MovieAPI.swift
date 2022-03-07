//
//  MovieAPI.swift
//  MovieDB MVC
//
//  Created by Rodrigo de Anhaia on 04/03/22.
//

import Foundation

struct MovieAPI {
    var movie: [Movie] = []
    
    func requestMovies(page: Int = 0, completionHandler: @escaping ([Movie]) -> Void) {
        if page < 0 { fatalError("Page should not be lower than 0") }
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=5bcebe37f3050767b767d16266b4398d"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            typealias MovieArray = [String: Any]
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any]
            
            else {
                completionHandler([])
                return
            }
            guard let movie = dictionary["results"] as? [MovieArray] else { return }
            
            var localMovie: [Movie] = []
            
            for movieDictionary in movie {
                guard let id = movieDictionary["id"] as? Int,
                      let title = movieDictionary["title"] as? String,
                      let overview = movieDictionary["overview"] as? String,
                      let posterPath = movieDictionary["poster_path"] as? String,
                      let voteAverage = movieDictionary["vote_average"] as? Double,
                      let releaseDate = movieDictionary["release_date"] as? String
                
                else { continue }
                let movie = Movie(id: id, title: title , overview: overview, posterPath: posterPath, voteAverage: voteAverage, releaseDate: releaseDate)
                
                localMovie.append(movie)
            }
            
            completionHandler(localMovie)
           
        }
        .resume()
        
    }
    
}
