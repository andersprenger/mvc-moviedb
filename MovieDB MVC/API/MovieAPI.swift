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
    private(set) var searchMovies: [Movie] = []
    
    private var genreDictionary: [Int: String] = [:]
    private var page = 1
    
    private let API_KEY = "5bcebe37f3050767b767d16266b4398d"
    
    init() {
        loadGenres()
    }
    
    /// Load movies from The Movie DB.
    ///
    /// - Parameters:
    ///     - from: the *urlString* which the movies will be requested.
    ///     - completionHandler: a function where the UI should be reloaded when the request is completed.
    ///
    private func requestMovies(from urlString: String, completionHandler: @escaping ([Movie]) -> Void) {
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
            
            guard let movies = dictionary["results"] as? [MovieArray] else { return }
            
            var localMovie: [Movie] = []
            
            for movieDictionary in movies {
                guard let movie = MovieParser.parseMovie(from: movieDictionary) else { continue }
                
                localMovie.append(movie)
            }
            
            completionHandler(localMovie)
        }
        .resume()
    }
    
    /// Load the now playing movies from The Movie DB.
    ///
    /// - Parameters:
    ///     - completionHandler: a function where the UI should be reloaded when the request is completed.
    ///
    func requestNowPlayingMovies(completionHandler: @escaping () -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API_KEY)&page=\(page)"
        
        requestMovies(from: urlString) { movies in
            self.nowPlayingMovies += movies
            self.page += 1
            completionHandler()
        }
    }
    
    /// Load the popular movies from The Movie DB.
    ///
    /// - Parameters:
    ///     - completionHandler: a function where the UI should be reloaded when the request is completed.
    ///
    func requestPopularMovies(completionHandler: @escaping () -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(API_KEY)"
        
        requestMovies(from: urlString) { movies in
            self.popularMovies += movies
            completionHandler()
        }
    }
    
    /// Load the popular movies from The Movie DB.
    ///
    /// - Parameters:
    ///     - searchText: the text that will be used to search the movies.
    ///     - completionHandler: a function where the UI should be reloaded when the request is completed.
    ///
    func searchMovie(searchText: String, completionHandler: @escaping () -> Void)  {
        self.searchMovies = []
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(API_KEY)&query=\(searchText)"
        let newUrlString  = urlString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        requestMovies(from: newUrlString) { movies in
            self.searchMovies += movies
            completionHandler()
        }
    }
    
    private func loadGenres() {
        let genresURL = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(API_KEY)")!
        
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
