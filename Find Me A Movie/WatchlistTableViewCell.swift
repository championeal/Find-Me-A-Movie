//
//  WatchlistTableViewCell.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 5/3/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class WatchlistTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var movie: Movie! {
        didSet {
            movie.getPosterImage(movieImageView)
            titleLabel.text = movie.title
            yearLabel.text = movie.year
        }
    }
}
