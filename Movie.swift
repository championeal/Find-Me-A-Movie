//
//  Movie.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation

class Movie {
    var id: Int
    var title: String
    var favorite = false
    var imdbID: String?
    var rtID: String?
    var themoviedbID: String?
    
    init(id:Int, title:String){
        self.id = id
        self.title = title
    }
    
    convenience init(id: Int, title: String, imdbID: String, rtID: String, tmdbID: String){
        self.init(id:id,title:title)
        self.imdbID = imdbID
        self.rtID = rtID
        self.themoviedbID = tmdbID
    }
}