//
//  SimilarMovies.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation

class SimilarMoviesService {
    let imdbURL = "http://www.imdb.com/title/"
    let rtURL = "http://www.rottentomatoes.com/m/"
    
    func getIMDB(imdbID:String) -> [String]{
        var movies = [String]()
        if let url = NSURL(string:imdbURL+imdbID) {
            if let doc = HTML(url: url, encoding: NSUTF8StringEncoding){
                //print(doc.title!+"\n")
                
                // Search for nodes by XPath
                //for title in doc.xpath("//div[@class='rec-title']/a") {
                //    print(title.text!)
                //}
                for id in doc.xpath("//div[@class='rec_poster']") {
                    movies.append(id["data-tconst"]!)
                }
            }
        }
        return movies
    }
}