//
//  MovieDetailTableViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 5/2/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class MovieDetailTableViewController: UITableViewController {

    var movie = Movie()
    let tmdbService = TheMovieDatabaseService()
    let smService = SimilarMoviesService()
    let omdbService = OpenMovieDatabaseService()
    let gbService = GuideboxService()

    @IBOutlet weak var backdropImageView: UIImageView! {
        didSet {
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
                backdropImageView.image = UIImage(named: "BackdropPlaceholder")
            }
        }
    }
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    @IBOutlet weak var imdbImageView: UIImageView!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var rottenTomatoesImageView: UIImageView!
    @IBOutlet weak var rottenTomatoesRatingLabel: UILabel!
    
    @IBOutlet weak var notInterestedButton: UIButton!
    @IBOutlet weak var watchlistButton: UIButton!
    @IBAction func setNotInterested(sender: UIButton) {
        updateList(Movie.List.NotInterested)
    }
    @IBAction func setWatchlist(sender: UIButton) {
        updateList(Movie.List.Watchlist)
    }
    
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func rateDislike(sender: UIButton) {
        updateRatings(Movie.Rating.Dislike)
    }
    @IBAction func rateOkay(sender: UIButton) {
        updateRatings(Movie.Rating.Okay)
    }
    @IBAction func rateLike(sender: UIButton) {
        updateRatings(Movie.Rating.Like)
    }
    @IBAction func rateFavorite(sender: UIButton) {
        updateRatings(Movie.Rating.Favorite)
    }
    
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get IMDB and RT ratings
        tmdbService.getMovie(movie.idTheMovieDB) {
            (movieTMDB) in
            self.movie.idIMDB = movieTMDB.idIMDB
            self.omdbService.getMovie(movieTMDB.idIMDB!) {
                (movieOMDB) in
                self.movie.ratingIMDB = movieOMDB.ratingIMDB
                self.movie.ratingRottenTomatoes = movieOMDB.ratingRottenTomatoes
                self.movie.typeRottenTomatoes  = movieOMDB.typeRottenTomatoes
                self.imdbRatingLabel.text = movieOMDB.ratingIMDB!+"/10"
                self.rottenTomatoesRatingLabel.text = movieOMDB.ratingRottenTomatoes!+"%"
                self.rottenTomatoesImageView.image = self.getRottenTomatoesImage(movieOMDB.typeRottenTomatoes!)
            }
        }
        
        // streaming services will be implemented next version
        /*gbService.getIDUsingTMDB(movie.idTheMovieDB) {
            (idGuidebox) in
            self.movie.idGuidebox = idGuidebox
            self.gbService.getMovie(idGuidebox) {
                (yes) in
            }
        }*/
        
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
        movie.getPosterImage(posterImageView)
        
        // set correct rating image for search controller
        if let index = ratedMovies.indexOf({ $0.idTheMovieDB == movie.idTheMovieDB }) {
            movie.rating = ratedMovies[index].rating
        }
        updateRatingImages()
        
        // set correct list button for search controller
        if let index = listedMovies.indexOf({ $0.idTheMovieDB == movie.idTheMovieDB }) {
            movie.list = listedMovies[index].list
        }
        updateListButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRottenTomatoesImage(type: String) -> UIImage? {
        var imageName = "RottenTomatoes-"
        if type == "N/A" {
            imageName += "rotten"
        }
        else {
            imageName += type
        }
        return UIImage(named: imageName)
    }
    
    
    // update list
    
    func updateList(list: Movie.List) {
        if movie.list == list {
            removeMovieFromList()
        }
        else {
            removeMovieFromList()
            movie.list = list
            listedMovies.append(movie)
        }
        updateListButtons()
        if movie.list == Movie.List.NotInterested {
            removeMovieFromRatings()
            updateRatingImages()
        }
    }
    
    func removeMovieFromList(){
        movie.list = Movie.List.None
        if let index = listedMovies.indexOf({ $0.idTheMovieDB == movie.idTheMovieDB }) {
            listedMovies.removeAtIndex(index)
        }
    }
    
    func updateListButtons(){
        if movie.list == Movie.List.NotInterested {
            notInterestedButton.setTitleColor(white, forState: .Normal)
            notInterestedButton.backgroundColor = red
            watchlistButton.setTitleColor(blue, forState: .Normal)
            watchlistButton.backgroundColor = white
        }
        else if movie.list == Movie.List.Watchlist {
            notInterestedButton.setTitleColor(red, forState: .Normal)
            notInterestedButton.backgroundColor = white
            watchlistButton.setTitleColor(white, forState: .Normal)
            watchlistButton.backgroundColor = blue
        }
        else {
            notInterestedButton.setTitleColor(red, forState: .Normal)
            notInterestedButton.backgroundColor = white
            watchlistButton.setTitleColor(blue, forState: .Normal)
            watchlistButton.backgroundColor = white
        }
        updateListImages()
    }
    
    func updateListImages(){
        notInterestedButton.setImage(imageForList(Movie.List.NotInterested), forState: .Normal)
        watchlistButton.setImage(imageForList(Movie.List.Watchlist), forState: .Normal)
    }
    
    func imageForList(list: Movie.List) -> UIImage? {
        var imageName = "\(list)"
        if movie.list == list {
            imageName += "-selected"
        }
        return UIImage(named: imageName)
    }
    
    
    // update ratings
    
    func updateRatings(rating: Movie.Rating){
        if movie.rating == rating {
            removeMovieFromRatings()
        }
        else {
            smService.getTheMovieDB(movie.idTheMovieDB){
                (similarMovies) in
                self.movie.similarTheMovieDB = similarMovies
                self.removeMovieFromRatings()
                self.movie.rating = rating
                ratedMovies.append(self.movie)
            }
            movie.rating = rating
        }
        updateRatingImages()
        if movie.list == Movie.List.NotInterested {
            removeMovieFromList()
            updateListButtons()
        }
    }
    
    func removeMovieFromRatings() {
        movie.rating = Movie.Rating.None
        if let index = ratedMovies.indexOf({ $0.idTheMovieDB == movie.idTheMovieDB }) {
            ratedMovies.removeAtIndex(index)
        }
    }
    
    func updateRatingImages(){
        dislikeButton.setImage(imageForRating(Movie.Rating.Dislike), forState: .Normal)
        okayButton.setImage(imageForRating(Movie.Rating.Okay), forState: .Normal)
        likeButton.setImage(imageForRating(Movie.Rating.Like), forState: .Normal)
        favoriteButton.setImage(imageForRating(Movie.Rating.Favorite), forState: .Normal)
    }
    
    func imageForRating(rating: Movie.Rating) -> UIImage? {
        var imageName = "\(rating)"
        if movie.rating == rating {
            imageName += "-filled"
        }
        return UIImage(named: imageName)
    }
}
