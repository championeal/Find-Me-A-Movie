//
//  RecommendationsTableViewCell.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/28/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class RecommendationsTableViewCell: UITableViewCell {
    let tmdbService = TheMovieDatabaseService()

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var similarRatingLabel: UILabel!
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            yearLabel.text = movie.year
            similarRatingLabel.text = "Rec Rating: \(round(1000*movie.similarRating!)/100)"
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
