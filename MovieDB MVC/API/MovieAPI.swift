//
//  MovieAPI.swift
//  MovieDB MVC
//
//  Created by Rodrigo de Anhaia on 04/03/22.
//

import Foundation
import UIKit

class MovieAPI {
    private(set) var popularMovies: [Movie] = []
    private(set) var nowPlayingMovies: [Movie] = []
    private(set) var searchMovie: [Movie] = []
    private var genreDictionary: [Int: String] = [:]
    private var page = 1
    
    private let API_KEY = "5bcebe37f3050767b767d16266b4398d"
    
    init() {
        loadGenres()
    }
    
    /// Load the now playing movies from The Movie DB.
    ///
    /// - Parameters:
    ///     - completionHandler: a function where the UI should be reloaded when the request is completed.
    ///
    func requestNowPlayingMovies(completionHandler: @escaping () -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API_KEY)&page=\(page)"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            typealias MovieArray = [String: Any]
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any]
                    
            else {
                completionHandler()
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
                      let releaseDate = movieDictionary["release_date"] as? String,
                      let genres = movieDictionary["genre_ids"] as? [Int]
                        
                else { continue }
                let movie = Movie(id: id, title: title , overview: overview, posterPath: posterPath, genres: genres, voteAverage: voteAverage, releaseDate: releaseDate)
                
                localMovie.append(movie)
            }
            
            self.nowPlayingMovies += localMovie
            self.page += 1
            completionHandler()
            
        }
        .resume()
    }
    
    /// Load the popular movies from The Movie DB.
    ///
    /// - Parameters:
    ///     - completionHandler: a function where the UI should be reloaded when the request is completed.
    ///
    func requestPopularMovies(completionHandler: @escaping () -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(API_KEY)"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            typealias MovieArray = [String: Any]
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any]
                    
            else {
                completionHandler()
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
                      let releaseDate = movieDictionary["release_date"] as? String,
                      let genres = movieDictionary["genre_ids"] as? [Int]
                        
                else { continue }
                let movie = Movie(id: id, title: title , overview: overview, posterPath: posterPath, genres: genres, voteAverage: voteAverage, releaseDate: releaseDate)
                
                localMovie.append(movie)
            }
            
            self.popularMovies += localMovie
            completionHandler()
            
        }
        .resume()
    }
    
    func searchMovie(searchText: String, completionHandler: @escaping () -> Void)  {
        self.searchMovie = []
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(API_KEY)&query=\(searchText)"
        let newUrlString  = urlString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let url = URL(string: newUrlString)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            typealias MovieArray = [String: Any]
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any]
                    
            else {
                completionHandler()
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
                      let releaseDate = movieDictionary["release_date"] as? String,
                      let genres = movieDictionary["genre_ids"] as? [Int]
                        
                else { continue }
                let movie = Movie(id: id, title: title , overview: overview, posterPath: posterPath, genres: genres, voteAverage: voteAverage, releaseDate: releaseDate)
                
                localMovie.append(movie)
            }
            
            self.searchMovie += localMovie
            completionHandler()
            
        }
        .resume()
    }
    
    private func loadGenres() {
        let genresURL = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=5bcebe37f3050767b767d16266b4398d")!
        
        URLSession.shared.dataTask(with: genresURL) { data, response, error in
            
            guard let data = data else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else { return }
            guard let dict = json as? [String: Any] else { return }
            guard let generes = dict["genres"] as? [[String: Any]] else { return }
            
            for g in generes {
                guard let id = g["id"] as? Int else { continue }
                guard let name = g["name"] as? String else { continue }
                
                self.genreDictionary.updateValue(name, forKey: id)
            }
        }
        .resume()
    }
    
    /// Return a String with the generes of a movie.
    ///
    /// - Parameters:
    ///     - of: the movie that will have its genres fetched.
    ///
    func getGeneresText(of movie: Movie) -> String {
        var str = ""
        
        let genres = movie.genres
        
        for g in genres {
            str += genreDictionary[g] ?? "nil"
            if g != genres.last {
                str += ", "
            }
        }
        
        return str
    }
    
    func reload(completionHandler: @escaping() -> ()) {
        nowPlayingMovies = []
        popularMovies = []
        page = 1
        
        requestNowPlayingMovies(completionHandler: completionHandler)
        requestPopularMovies(completionHandler: completionHandler)
    }
}
