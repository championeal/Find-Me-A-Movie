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
    var year: String?
    var description: String?
    var favorite = false
    var idGuidebox: String?
    var idIMDB: String?
    var idRottenTomatoes: String?
    var idTheMovieDB: String
    var similarIMDB: [String]?
    var similarTheMovieDB: [String]?
    var similarRating: Float?
    var posterURL: String?
    var posterImage: UIImage?
    var backdropURL: String?
    var backdropImage: UIImage?
    enum List {
        case None
        case NotInterested
        case Watchlist
    }
    var list = List.None
    enum Rating {
        case None
        case Dislike
        case Okay
        case Like
        case Favorite
    }
    var rating = Rating.None
    
    var ratingIMDB: String?
    var imageIMDB: UIImage?
    var ratingRottenTomatoes: String?
    var typeRottenTomatoes: String?
    var imageRottenTomatoes: UIImage?
    
    // test initializer
    init(){
        self.title = "test"
        self.idTheMovieDB = "-1"
    }
    
    /*init(id:Int, title:String){
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
    }*/
    
    
    // TheMovieDatabaseService initializers
    init(title: String, release_date: String, overview: String, idTMDB: String, poster_path: String, backdrop_path: String) {
        if release_date.characters.count < 5 {
            self.year = release_date
        }
        else {
            let index = release_date.startIndex.advancedBy(4)
            self.year = release_date.substringToIndex(index)
        }
        self.title = title
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
    
    convenience init(backdrop_path: String, idTMDB: String, idIMDB: String, overview: String, poster_path: String, release_date: String, title: String) {
        self.init(title: title, release_date: release_date, overview: overview, idTMDB: idTMDB, poster_path: poster_path, backdrop_path: backdrop_path)
        self.idIMDB = idIMDB
    }
    
    // OpenMovieDatabaseService Initializers
    convenience init(imdbRating: String, tomatoMeter: String, tomatoImage: String){
        self.init()
        ratingIMDB = imdbRating
        ratingRottenTomatoes = tomatoMeter
        typeRottenTomatoes = tomatoImage
    }
    
    
    func getPosterImage(imageView: UIImageView) {
        let tmdbService = TheMovieDatabaseService()
        if let poster = posterImage {
            imageView.image = poster
        }
        else if let url = posterURL {
            print(url)
            tmdbService.getImage(url) {
                (image) in
                self.posterImage = image
                imageView.image = image
            }
        }
        else {
            if let image = UIImage(named: "PosterPlaceholder"){
                posterImage = image
                imageView.image = image
            }
        }
    }
}