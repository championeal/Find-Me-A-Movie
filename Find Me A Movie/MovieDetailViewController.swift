//
//  MovieDetailViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/19/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    let tmdbService = TheMovieDatabaseService()
    var movie: Movie?
    
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = self.movie {
            movieNameLabel.text = movie.title
            movieDescriptionLabel.text = movie.description
            if let backdrop = movie.backdrop {
                self.backdropImageView.image = backdrop
            }
            else {
                tmdbService.getBackdrop(movie.backdropURL!) {
                    (image) in
                    movie.backdrop = image
                    self.backdropImageView.image = image
                    // http://stackoverflow.com/questions/31859263/ios-fade-to-black-at-top-of-uiimageview
                    let gradient: CAGradientLayer = CAGradientLayer()
                    gradient.frame = self.backdropImageView.bounds
                    gradient.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor]
                    gradient.locations = [0.0, 1.0]
                    self.backdropImageView.layer.insertSublayer(gradient, atIndex: 0)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
