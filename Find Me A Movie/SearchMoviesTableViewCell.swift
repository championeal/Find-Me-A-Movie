//
//  SearchMoviesTableViewCell.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/21/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class SearchMoviesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            yearLabel.text = movie.year
            movie.getPosterImage(movieImageView)
        }
    }
}
