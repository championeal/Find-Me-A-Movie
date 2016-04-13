//
//  TheMovieDatabaseService.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/12/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation

class TheMovieDatabaseService {
    let APIkey = "51dc4d245f1e4da77d735dd774b429c2"
    let baseURL = "https://api.themoviedb.org/3/"
    var resultJSON: String?
    var imageBaseURL = "https://image.tmdb.org/t/p/"
    var backdropSizes = [String]()
    var imageSizes = [String]()
    
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
                    let movie = Movie(title:movieResult["title"].stringValue, idIMDB: String(idIMDB), idTMDB: String(movieResult["id"].intValue))
                    dispatch_async(GlobalMainQueue, {
                        callback(movie)
                    })
                }
            }
            task.resume()
        })
    }
}