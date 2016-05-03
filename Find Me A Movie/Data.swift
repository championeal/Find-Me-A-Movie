//
//  Data.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/25/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation
import UIKit

let defaults = NSUserDefaults.standardUserDefaults()

var ratedMovies: [Movie] {
    get {
        var movies = [Movie]()
        if let data = defaults.objectForKey("ratedMovies") as? NSData {
            movies = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Movie] ?? [Movie]()
        }
        return movies
    }
    set (newValue){
        let data = NSKeyedArchiver.archivedDataWithRootObject(newValue)
        defaults.setObject(data, forKey: "ratedMovies")
    }
}


var listedMovies: [Movie] {
    get {
        var movies = [Movie]()
        if let data = defaults.objectForKey("listedMovies") as? NSData {
            movies = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Movie] ?? [Movie]()
        }
        return movies
    }
    set (newValue){
        let data = NSKeyedArchiver.archivedDataWithRootObject(newValue)
        defaults.setObject(data, forKey: "listedMovies")
    }
}


let white = UIColor(white: 1, alpha: 1)
let red = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
let blue = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
let green = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1)