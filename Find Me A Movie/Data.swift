//
//  Data.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/25/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation
import UIKit

var ratedMovies = [Movie]() {
    didSet {
        
    }
}

var listedMovies = [Movie]()


let white = UIColor(white: 1, alpha: 1)
let red = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
let blue = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)