//
//  AddFavoritesTableViewCell.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class AddFavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addFavoriteButton: UIButton!
    
    weak var delegate:AddFavoritesTableViewCellDelegate?
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            if(movie.favorite){
                addFavoriteButton.setTitle("✓ Added", forState: .Normal)
            }
            else{
                addFavoriteButton.setTitle("✚ Add Favorite", forState: .Normal)
            }
        }
    }
    
    @IBAction func toggleFavorite(sender: UIButton) {
        if(movie.favorite){
            sender.setTitle("✚ Add Favorite", forState: .Normal)
            delegate!.removeFavorite(movie.id)
        }
        else{
            sender.setTitle("✓ Added", forState: .Normal)
            delegate!.addFavorite(movie.id)
        }
        movie.favorite = !movie.favorite
    }
    
}

protocol AddFavoritesTableViewCellDelegate: class {
    func addFavorite(id:Int)
    func removeFavorite(id:Int)
}
