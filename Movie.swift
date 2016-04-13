//
//  Movie.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation

class Movie {
    var id: Int?
    var title: String
    var favorite = false
    var idIMDB: String?
    var idRottenTomatoes: String?
    var idTheMovieDB: String?
    var similarIMDB: [String]?
    var similarScore: Int?
    var posterURL: String?
    var backdropURL: String?
    
    init(id:Int, title:String){
        self.id = id
        self.title = title
    }
    
    convenience init(id: Int, title: String, idIMDB: String, idRT: String, idTMDB: String){
        self.init(id:id,title:title)
        self.idIMDB = idIMDB
        self.idRottenTomatoes = idRT
        self.idTheMovieDB = idTMDB
    }
    
    init(title: String, idIMDB: String, idTMDB: String, imagePosterURL: String, imageBackdropURL: String) {
        self.title = title
        self.idIMDB = idIMDB
        self.idTheMovieDB = idTMDB
        self.posterURL = imagePosterURL
        self.backdropURL = imageBackdropURL
    }
}