//
//  RecommendationsTableViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/25/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class RecommendationsTableViewController: UITableViewController {

    var recommendedMovies = [Movie]()
    let tmdbService = TheMovieDatabaseService()
    weak var delegate:MoviesTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        recommendedMovies = [Movie]()
        var recommendations = [String:Float]()
        tableView.reloadData()
        for movie in ratedMovies {
            if let similarMovies = movie.similarTheMovieDB {
                var multiplier:Float = 0
                if movie.rating == Movie.Rating.Favorite {
                    multiplier = 2
                }
                else if movie.rating == Movie.Rating.Like {
                    multiplier = 1
                }
                else if movie.rating == Movie.Rating.Okay {
                    continue
                }
                else if movie.rating == Movie.Rating.Dislike {
                    multiplier = -1
                }
                for similar in similarMovies {
                    // only add recommendation if not in ratings or list
                    if ratedMovies.indexOf({ $0.idTheMovieDB == similar }) < 0 && listedMovies.indexOf({ $0.idTheMovieDB == similar }) < 0 {
                        var rating = Float(similarMovies.indexOf(similar)!)+1
                        rating = multiplier/rating
                        if let _ = recommendations[similar] {
                            recommendations[similar]! += rating
                        }
                        else {
                            recommendations[similar] = rating
                        }
                    }
                }
            }
        }
        let sortedRecs = recommendations.sort{$0.1 > $1.1}
        print(sortedRecs)
        //let sortedTitles = sortedRecs.map {return $0.0}
        var i = 0
        for rec in sortedRecs {
            let id = rec.0
            let rating = rec.1
            if rating > 0.1 {
                    i++
                tmdbService.getMovie(id) {
                    (movie) in
                    self.recommendedMovies.append(movie)
                    movie.similarRating = rating
                    //update the tableView
                    /*self.tableView.beginUpdates()
                    let indexPath = NSIndexPath(forRow: self.recommendedMovies.count-1, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()*/
                    self.recommendedMovies.sortInPlace({ $0.similarRating > $1.similarRating })
                    self.tableView.reloadData()
                }
            }
            if(i >= 10) {
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedMovies.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecommendationsCell", forIndexPath: indexPath) as! RecommendationsTableViewCell

        let rec = recommendedMovies[indexPath.row] as Movie
        cell.movie = rec
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC =
            segue.destinationViewController as? MovieDetailTableViewController,
            cell = sender as? UITableViewCell,
            indexPath = self.tableView.indexPathForCell(cell),
            movie = recommendedMovies[indexPath.row] as Movie?{
                destVC.movie = movie
        }
    }

}
