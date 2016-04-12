//
//  Favorite.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import Foundation

class Favorite: Movie {
    var similar: [Int]?
    let sm = SimilarMoviesService()
    
    override init(id: Int){
        /*dispatch_async(dispatch_get_main_queue(), {
            similar = sm.getIMDB(id)
        })*/
        super.init(id: id)
    }
}