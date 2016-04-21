//
//  TheMovieDatabaseService.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/12/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation
import UIKit

class TheMovieDatabaseService {
    let APIkey = "51dc4d245f1e4da77d735dd774b429c2"
    let baseURL = "https://api.themoviedb.org/3/"
    var resultJSON: String?
    var imageBaseURL = "https://image.tmdb.org/t/p/"
    var backdropSizes = [String]()
    var imageSizes = [String]()
    
    //poster_sizes = ["w92","w154","w185","w342","w500","w780","original"]
    //backdrop_sizes = ["w300","w780","w1280","original"]
    
    func configuration(){
        dispatch_async(GlobalMainQueue, {
            var fullURL = self.baseURL+"configuration?api_key="+self.APIkey
            fullURL = fullURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string: fullURL)
            let request = NSMutableURLRequest(URL: url!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    let result = String(data: data!, encoding: NSASCIIStringEncoding)!
                    self.resultJSON = result
                    let json = JSON(data: data!)
                    self.imageBaseURL = json["secure_base_url"].stringValue
                    //for size in json["backdrop_sizes"] {
                    //    backdropSizes.append(size)
                    //}
                    //self.backdropSizes = json["backdrop_sizes"]
                    
                }
            }
            task.resume()
        })
    }
    
    /*func getMovie(id: String, callback: (Movie) -> Void ) {
        dispatch_async(GlobalUserInitiatedQueue, {
            var searchURL = self.baseURL+"movie/"+id+"?external_source=imdb_id&api_key="+self.APIkey
            searchURL = searchURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string: searchURL)
            let request = NSMutableURLRequest(URL: url!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    let result = String(data: data!, encoding: NSASCIIStringEncoding)!
                    self.resultJSON = result
                    let json = JSON(data: data!)
                    let movieResult = json["movie_results"][0]
                    let movie = Movie()
                    dispatch_async(GlobalMainQueue, {
                        callback(movie)
                    })
                }
            }
            task.resume()
        })
    }*/
    
    func searchMovies(search: String, callback: ([Movie]) -> Void ) {
        dispatch_async(GlobalUserInitiatedQueue, {
            var searchURL = self.baseURL+"search/movie?query=\(search)&api_key="+self.APIkey
            searchURL = searchURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string: searchURL)
            let request = NSMutableURLRequest(URL: url!)
            let session = NSURLSession.sharedSession()
            var movies = [Movie]()
            let task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    let result = String(data: data!, encoding: NSASCIIStringEncoding)!
                    self.resultJSON = result
                    let json = JSON(data: data!)
                    for (_, movie) in json["results"] {   // using _ in place of index
                        movies.append(Movie(title: movie["title"].stringValue, release_date: movie["release_date"].stringValue, overview: movie["overview"].stringValue, idTMDB: String(movie["id"].intValue), poster_path: movie["poster_path"].stringValue, backdrop_path: movie["backdrop_path"].stringValue))
                    }
                    dispatch_async(GlobalMainQueue, {
                        callback(movies)
                    })
                }
            }
            task.resume()
        })
    }
    
    func findMovieUsingIMDB(idIMDB: String, callback: (Movie) -> Void ) {
        dispatch_async(GlobalUserInitiatedQueue, {
            var searchURL = self.baseURL+"find/"+idIMDB+"?external_source=imdb_id&api_key="+self.APIkey
            searchURL = searchURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string: searchURL)
            let request = NSMutableURLRequest(URL: url!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    let result = String(data: data!, encoding: NSASCIIStringEncoding)!
                    self.resultJSON = result
                    let json = JSON(data: data!)
                    let movieResult = json["movie_results"][0]
                    let movie = Movie(title: movieResult["title"].stringValue, overview: movieResult["overview"].stringValue ,idIMDB: String(idIMDB), idTMDB: String(movieResult["id"].intValue), imagePosterURL: movieResult["poster_path"].stringValue, imageBackdropURL: movieResult["backdrop_path"].stringValue)
                    dispatch_async(GlobalMainQueue, {
                        callback(movie)
                    })
                }
            }
            task.resume()
        })
    }
    
    func getImage(url: String, callback: (UIImage) -> Void ) {
        dispatch_async(GlobalUserInitiatedQueue, {
            var image = UIImage()
            let imageURL = self.imageBaseURL+"w92"+url
            if let url = NSURL(string: imageURL),
                data = NSData(contentsOfURL: url) {
                    image = UIImage(data: data)!
            }
            dispatch_async(GlobalMainQueue, {
                callback(image)
            })
        })
    }
    
    func getBackdrop(url: String, callback: (UIImage) -> Void ) {
        dispatch_async(GlobalUserInitiatedQueue, {
            var backdrop = UIImage()
            let backdropURL = self.imageBaseURL+"w780"+url
            if let url = NSURL(string: backdropURL),
                data = NSData(contentsOfURL: url) {
                    backdrop = UIImage(data: data)!
            }
            dispatch_async(GlobalMainQueue, {
                callback(backdrop)
            })
        })
    }
}