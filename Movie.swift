//
//  Movie.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    var title: String
    var releaseDate: String?
    var description: String?
    var favorite = false
    var idGuidebox: String?
    var idIMDB: String?
    var idRottenTomatoes: String?
    var idTheMovieDB: String?
    var similarIMDB: [String]?
    var similarRating: Float?
    var posterURL: String?
    var posterImage: UIImage?
    var backdropURL: String?
    var backdropImage: UIImage?
    
    init(id:Int, title:String){
        self.idGuidebox = "\(id)"
        self.title = title
    }
    
    convenience init(id: Int, title: String, idIMDB: String, idRT: String, idTMDB: String){
        self.init(id:id,title:title)
        self.idIMDB = idIMDB
        self.idRottenTomatoes = idRT
        self.idTheMovieDB = idTMDB
    }
    
    init(title: String, overview: String, idIMDB: String, idTMDB: String, imagePosterURL: String, imageBackdropURL: String) {
        self.title = title
        self.description = overview
        self.idIMDB = idIMDB
        self.idTheMovieDB = idTMDB
        self.posterURL = imagePosterURL
        self.backdropURL = imageBackdropURL
    }
    init(title: String, release_date: String, overview: String, idTMDB: String, poster_path: String, backdrop_path: String) {
        self.title = title
        self.releaseDate = release_date
        self.description = overview
        self.idTheMovieDB = idTMDB
        if(poster_path == "") {
            self.posterURL = nil
        }
        else {
            self.posterURL = poster_path
        }
        if(backdrop_path == "") {
            self.backdropURL = nil
        }
        else {
            self.backdropURL = backdrop_path
        }
    }
}