//
//  Movie.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation
import UIKit

class Movie: NSObject, NSCoding {
    var title: String
    var year: String?
    var overview: String?
    var idGuidebox: String?
    var idIMDB: String?
    var idRottenTomatoes: String?
    var idTheMovieDB: String
    var similarTheMovieDB: [String]?
    var similarRating: Float?
    var posterURL: String?
    var posterImage: UIImage?
    var backdropURL: String?
    var backdropImage: UIImage?
    enum List: String {
        case None
        case NotInterested
        case Watchlist
    }
    var list = List.None
    enum Rating: String {
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
    override init(){
        self.title = "test"
        self.idTheMovieDB = "-1"
    }
    
    
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
        self.overview = overview
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
    
    // set poster image
    func getPosterImage(imageView: UIImageView) {
        let tmdbService = TheMovieDatabaseService()
        if let poster = posterImage {
            imageView.image = poster
        }
        else if let url = posterURL {
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
    
    // persistence
    
    init(
        title: String,
        year: String,
        overview: String,
        idTheMovieDB: String,
        similarTheMovieDB: [String],
        posterURL: String,
        backdropURL: String,
        list: List,
        rating: Rating
        ) {
            self.title = title
            self.year = year
            self.overview = overview
            self.idTheMovieDB = idTheMovieDB
            self.similarTheMovieDB = similarTheMovieDB
            self.posterURL = posterURL
            self.backdropURL = backdropURL
            self.list = list
            self.rating = rating
            
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let similarTheMovieDB = decoder.decodeObjectForKey("similarTheMovieDB") as? [String] ?? [String]()
        guard let title = decoder.decodeObjectForKey("title") as? String,
            let year = decoder.decodeObjectForKey("year") as? String,
            let overview = decoder.decodeObjectForKey("overview") as? String,
            let idTheMovieDB = decoder.decodeObjectForKey("idTheMovieDB") as? String,
            let posterURL = decoder.decodeObjectForKey("posterURL") as? String,
            let backdropURL = decoder.decodeObjectForKey("backdropURL") as? String,
            let list = List(rawValue: decoder.decodeObjectForKey("list") as! String),
            let rating = Rating(rawValue: decoder.decodeObjectForKey("rating") as! String)
            else { return nil }
        
        
        self.init(
            title: title,
            year: year,
            overview: overview,
            idTheMovieDB: idTheMovieDB,
            similarTheMovieDB: similarTheMovieDB,
            posterURL: posterURL,
            backdropURL: backdropURL,
            list: list,
            rating: rating
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(title, forKey: "title")
        coder.encodeObject(year, forKey: "year")
        coder.encodeObject(overview, forKey: "overview")
        coder.encodeObject(idTheMovieDB, forKey: "idTheMovieDB")
        coder.encodeObject(similarTheMovieDB, forKey: "similarTheMovieDB")
        coder.encodeObject(posterURL, forKey: "posterURL")
        coder.encodeObject(backdropURL, forKey: "backdropURL")
        coder.encodeObject(list.rawValue, forKey: "list")
        coder.encodeObject(rating.rawValue, forKey: "rating")
    }
}