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

    
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
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
                backdropImageView.image = UIImage(named: "backdropPlaceholder")
            }
        }
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
    
    func updateRatings(rating: Movie.Rating){
        if movie.rating == rating {
            movie.rating = Movie.Rating.None
            if let index = ratings.indexOf({ $0.idTheMovieDB == movie.idTheMovieDB }) {
                ratings.removeAtIndex(index)
            }
        }
        else {
            movie.rating = rating
            if let index = ratings.indexOf({ $0.idTheMovieDB == movie.idTheMovieDB }) {
                ratings[index].rating = rating
            }
            else {
                ratings.append(movie)
            }
        }
        updateImages()
        //parent?.saveFavorite(self)
        for movie in ratings {
            print(movie.title, movie.rating)
        }
    }
    
    func imageForRating(rating: Movie.Rating) -> UIImage? {
        var imageName = ""
        if movie.rating == rating {
            imageName = "\(rating)Filled"
        }
        else {
            imageName = "\(rating)"
        }
        return UIImage(named: imageName)
    }
    
    func updateImages(){
        dislikeButton.setImage(imageForRating(Movie.Rating.Dislike), forState: .Normal)
        okayButton.setImage(imageForRating(Movie.Rating.Okay), forState: .Normal)
        likeButton.setImage(imageForRating(Movie.Rating.Like), forState: .Normal)
        favoriteButton.setImage(imageForRating(Movie.Rating.Favorite), forState: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.description
        posterImageView.image = movie.posterImage
        // set correct rating image
        if let index = ratings.indexOf({ $0.idTheMovieDB == movie.idTheMovieDB }) {
            movie.rating = ratings[index].rating
        }
        updateImages()
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
