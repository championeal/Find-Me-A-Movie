//
//  MovieCollectionViewCell.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/12/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    let tmdbService = TheMovieDatabaseService()
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    var movie: Movie! {
        didSet {
            tmdbService.getImage(movie.posterURL!) {
                (image) in
                self.movieImageView.image = image
            }
        }
    }
}
