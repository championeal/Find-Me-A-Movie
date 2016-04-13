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
        dispatch_async(GlobalUserInitiatedQueue, {
            var searchURL = self.baseURL+self.APIkey+"/search/movie/title/\(search)"
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
                    for (_, movie) in json["results"] {   // using _ in place of key because I don't care about the key (actually the index)
                        movies.append(Movie(id:movie["id"].intValue, title:movie["title"].stringValue, idIMDB: movie["imdb"].stringValue, idRT: String(movie["rottentomatoes"].intValue), idTMDB: String(movie["themoviedb"].intValue)))
                    }
                    dispatch_async(GlobalMainQueue, {
                        callback(movies)
                    })
                }
            }
            task.resume()
        })
    }
    
    func getMovie(id: Int, favorite: Bool, callback: (Movie) -> Void ) {
        var searchURL = baseURL+APIkey+"/movie/\(id)"
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
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.resultJSON = result
                    let json = JSON(data: data!)
                    let movie: Movie?
                    if(favorite){
                        movie = Movie(id: id, title: json["title"].stringValue, idIMDB: json["imdb"].stringValue, idRT: String(json["rottentomatoes"].intValue), idTMDB: String(json["themoviedb"].intValue))
                        callback(movie!)
                    }
                })
                
            }
        }
        task.resume()
    }
    
    func searchMoviesUsingIMDB(idIMDB: String, callback: (Movie) -> Void ) {
        dispatch_async(GlobalUserInitiatedQueue, {
            var searchURL = self.baseURL+self.APIkey+"/search/movie/id/imdb/\(idIMDB)"
            searchURL = searchURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let delayInSeconds = 1.0
            let popTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(delayInSeconds * Double(NSEC_PER_SEC))) // 1
            dispatch_after(popTime, GlobalMainQueue) {
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
                        let movie = Movie(id: json["id"].intValue, title: json["title"].stringValue, idIMDB: json["imdb"].stringValue, idRT: String(json["rottentomatoes"].intValue), idTMDB: String(json["themoviedb"].intValue))
                        dispatch_async(GlobalMainQueue, {
                            callback(movie)
                        })
                    }
                }
            task.resume()
            }
        })
    }
}