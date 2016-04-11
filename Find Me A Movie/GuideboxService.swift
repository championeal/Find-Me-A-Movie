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
    let APIkey: String
    var resultJSON: String?
    
    init(apikey: String) {
        self.APIkey = apikey
    }
    
    func search(search: String, callback: ([Movie]) -> Void ) {
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
}