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
    let white = UIColor(white: 1, alpha: 1)
    let red = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
    let blue = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)

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
        tableView.rowHeight = UITableViewAutomaticDimension
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.description
        posterImageView.image = movie.posterImage
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateList(list: Movie.List) {
        if movie.list == list {
            removeMovieFromList()
        }
        else {
            movie.list = list
            if let index = listedMovies.indexOf({ $0.idTheMovieDB == movie.idTheMovieDB }) {
                listedMovies[index].list = list
            }
            else {
                listedMovies.append(movie)
            }
        }
        updateListButtons()
        if movie.list == Movie.List.NotInterested {
            removeMovieFromRatings()
            updateRatingImages()
        }
        for movie in listedMovies {
            print(movie.title, movie.list)
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
        var imageName = ""
        if movie.list == list {
            imageName = "\(list)-selected"
        }
        else {
            imageName = "\(list)"
        }
        return UIImage(named: imageName)
    }
    
    func updateRatings(rating: Movie.Rating){
        if movie.rating == rating {
            removeMovieFromRatings()
        }
        else {
            smService.getTheMovieDB(movie.idTheMovieDB){
                (similarMovies) in
                self.movie.similarTheMovieDB = similarMovies
                print(self.movie.similarTheMovieDB)
            }
            movie.rating = rating
            if let index = ratedMovies.indexOf({ $0.idTheMovieDB == movie.idTheMovieDB }) {
                ratedMovies[index].rating = rating
            }
            else {
                ratedMovies.append(movie)
            }
        }
        updateRatingImages()
        if movie.list == Movie.List.NotInterested {
            removeMovieFromList()
            updateListButtons()
        }
        for movie in ratedMovies {
            print(movie.title, movie.rating)
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
        var imageName = ""
        if movie.rating == rating {
            imageName = "\(rating)-filled"
        }
        else {
            imageName = "\(rating)"
        }
        return UIImage(named: imageName)
    }
    
    /*override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }*/
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
