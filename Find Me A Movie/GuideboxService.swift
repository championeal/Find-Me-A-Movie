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

    func getMovie(id: String, callback: (Bool) -> Void ) {
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
                    for (_,item) in json["purchase_ios_sources"] {
                        print(item)
                        print(item["source"])
                    }
                })
                
            }
        }
        task.resume()
    }
    
    func getIDUsingTMDB(idTMDB: String, callback: (String) -> Void ) {
        dispatch_async(GlobalUserInitiatedQueue, {
            var searchURL = self.baseURL+self.APIkey+"/search/movie/id/themoviedb/\(idTMDB)"
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
                        let id = String(json["id"].intValue)
                        dispatch_async(GlobalMainQueue, {
                            callback(id)
                        })
                    }
                }
            task.resume()
            }
        })
    }
}