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
    var title: String?
    var favorite = false
    
    init(id:Int){
        self.id = id
    }
    
    convenience init(id:Int, title:String){
        self.init(id: id)
        self.title = title
    }
}