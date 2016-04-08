//
//  movie.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/7/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation

class Movie {
    var id: Int
    var title: String
    
    init(id:Int, title:String){
        self.id = id
        self.title = title
    }
}