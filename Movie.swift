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
    var idIMDB: String?
    var idRottenTomatoes: String?
    var idTheMovieDB: String?
    var similarIMDB: [String]?
    
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
}