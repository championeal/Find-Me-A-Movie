//
//  OpenMovieDatabaseService.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 5/3/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation

class OpenMovieDatabaseService {
    let baseURL = "http://www.omdbapi.com/?plot=short&r=json&tomatoes=true&i="
    
    func getMovie(idIMDB: String, callback: (Movie) -> Void ) {
        dispatch_async(GlobalUserInitiatedQueue) {
            var fullURL = self.baseURL+idIMDB
            fullURL = fullURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string: fullURL)
            let request = NSMutableURLRequest(URL: url!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    //let result = String(data: data!, encoding: NSASCIIStringEncoding)!
                    //self.resultJSON = result
                    let json = JSON(data: data!)
                    dispatch_async(GlobalMainQueue) {
                        callback(Movie(imdbRating: json["imdbRating"].stringValue, tomatoMeter: json["tomatoMeter"].stringValue, tomatoImage: json["tomatoImage"].stringValue))
                    }
                }
            }
            task.resume()
        }
    }
}