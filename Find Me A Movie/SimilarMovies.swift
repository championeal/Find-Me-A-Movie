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
    let tmdbURL = "https://www.themoviedb.org/movie/"
    
    func getIMDB(idIMDB: String, callback: ([String]) -> Void ){
        dispatch_async(GlobalUserInitiatedQueue) {
            var movies = [String]()
            if let url = NSURL(string:self.imdbURL+idIMDB) {
                if let doc = HTML(url: url, encoding: NSUTF8StringEncoding){
                    for id in doc.xpath("//div[@class='rec_poster']") {
                        movies.append(id["data-tconst"]!)
                    }
                    dispatch_async(GlobalMainQueue) {
                        callback(movies)
                    }
                }
            }
        }
    }
    
    func getTheMovieDB(idTheMovieDB: String, callback: ([String]) -> Void ){
        dispatch_async(GlobalUserInitiatedQueue) {
            var movies = [String]()
            if let url = NSURL(string:self.tmdbURL+idTheMovieDB+"/recommended") {
                if let doc = HTML(url: url, encoding: NSUTF8StringEncoding){
                    for href in doc.xpath("//tr/td/a/@href"){
                        let text = href.text!
                        let index = text.startIndex.advancedBy(7)
                        let id = text.substringFromIndex(index)
                        movies.append(id)
                    }
                    dispatch_async(GlobalMainQueue) {
                        callback(movies)
                    }
                }
            }
        }
    }
}