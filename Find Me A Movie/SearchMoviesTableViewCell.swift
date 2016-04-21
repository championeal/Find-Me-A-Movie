//
//  SearchMoviesTableViewCell.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/21/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class SearchMoviesTableViewCell: UITableViewCell {
    let tmdbService = TheMovieDatabaseService()
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            yearLabel.text = movie.releaseDate
            if let poster = movie.posterImage {
                self.movieImageView.image = poster
            }
            else if let url = movie.posterURL {
                print(url)
                tmdbService.getImage(url) {
                    (image) in
                    self.movie.posterImage = image
                    self.movieImageView.image = image
                }
            }
            else {
                movieImageView.image = UIImage(named: "posterPlaceholder")
            }
        }
    }
}
