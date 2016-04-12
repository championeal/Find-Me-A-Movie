//
//  GuideboxService.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation

class GuideboxService {
    let baseURL = "https://api-public.guidebox.com/v1.43/US/"
    let APIkey = "rK8nuMrG5dZYDqZZFfDb2QO8dk1ATzmB"
    var resultJSON: String?
    
    func searchMovies(search: String, callback: ([Movie]) -> Void ) {
        var searchURL = baseURL+APIkey+"/search/movie/title/\(search)"
        searchURL = searchURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url = NSURL(string: searchURL)
        let request = NSMutableURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        var movies = [Movie]()
        let task = session.dataTaskWithRequest(request){
            (data, responseText, error) -> Void in
            if error != nil {
                print(error)
            } else {
                let result = String(data: data!, encoding: NSASCIIStringEncoding)!
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.resultJSON = result
                    let json = JSON(data: data!)
                    for (_, movie) in json["results"] {   // using _ in place of key because I don't care about the key (actually the index)
                        movies.append(Movie(id:movie["id"].intValue, title:movie["title"].stringValue))
                    }
                    callback(movies)
                })
                
            }
        }
        task.resume()
    }
    
    func getMovie(id: Int, favorite: Bool, callback: (Movie) -> Void ) {
        var searchURL = baseURL+APIkey+"/movie/\(id)"
        searchURL = searchURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url = NSURL(string: searchURL)
        let request = NSMutableURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, responseText, error) -> Void in
            if error != nil {
                print(error)
            } else {
                let result = String(data: data!, encoding: NSASCIIStringEncoding)!
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.resultJSON = result
                    let json = JSON(data: data!)
                    let movie: Movie?
                    if(favorite){
                        movie = Movie(id: id, title: json["title"].stringValue, imdbID: json["imdb"].stringValue, rtID: String(json["rottentomatoes"].intValue), tmdbID: String(json["themoviedb"].intValue))
                        callback(movie!)
                    }
                })
                
            }
        }
        task.resume()
    }
}