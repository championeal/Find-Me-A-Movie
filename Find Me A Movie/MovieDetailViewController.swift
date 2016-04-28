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
    let smService = SimilarMoviesService()
    var movie = Movie()
    let backdropGradient: CAGradientLayer = CAGradientLayer()
    var imageName = ""
    
    @IBOutlet weak var movieNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func disliked(sender: UIButton) {
    }
    @IBAction func liked(sender: UIButton) {
    }
    @IBAction func favorited(sender: UIButton) {
        movie.favorite = !movie.favorite
        if(movie.favorite){
            if let id = movie.idIMDB {
                smService.getIMDB(id) {
                    (similarMovies) in
                    self.movie.similarIMDB = similarMovies
                    print(self.movie.similarIMDB)
                }
            }
        }
        sender.setImage(imageForRating(movie.favorite, type: "favorite"), forState: .Normal)
        if let index = ratings.indexOf({ $0.idTheMovieDB == movie.idTheMovieDB }) {
            ratings.removeAtIndex(index)
        }
        else {
            ratings.append(movie)
        }
        //parent?.saveFavorite(self)
        for movie in ratings {
            print(movie.title)
        }
    }
    
    func imageForRating(yes: Bool, type: String) -> UIImage? {
        if yes {
            imageName = type+"Filled"
        }
        else {
            imageName = type
        }
        return UIImage(named: imageName)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie.idTheMovieDB)
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.description
        dislikeButton.setImage(imageForRating(false, type:"dislike"), forState: .Normal)
        likeButton.setImage(imageForRating(false, type:"like"), forState: .Normal)
        favoriteButton.setImage(imageForRating(movie.favorite, type:"favorite"), forState: .Normal)
        if let backdrop = movie.backdropImage {
            backdropImageView.image = backdrop
        }
        else if let url = movie.backdropURL {
            tmdbService.getBackdrop(url) {
                (image) in
                self.movie.backdropImage = image
                self.backdropImageView.image = self.movie.backdropImage
            }
        }
        else {
            //self.backdropImageView.removeFromSuperview()
            //self.backdropImageView = nil
            //self.movieNameConstraint.constant = 72
            //self.movieNameConstraint.
        }
        //self.setBackdropGradient()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackdropGradient() {
        // http://stackoverflow.com/questions/31859263/ios-fade-to-black-at-top-of-uiimageview
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.backdropImageView.frame
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor]
        gradient.locations = [0.0, 1.0]
        self.backdropImageView.layer.insertSublayer(gradient, atIndex: 0)
    }

    override func didMoveToParentViewController(parent: UIViewController?) {
        print("hello")
        if movie.favorite {
            smService.getTheMovieDB(movie.idTheMovieDB){
                (similarMovies) in
                self.movie.similarTheMovieDB = similarMovies
                print(self.movie.similarTheMovieDB)
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }

}
