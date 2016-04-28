//
//  RecommendationsTableViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/25/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class RecommendationsTableViewController: UITableViewController {
    
    var recommendations = [String:Float]()
    var recommendedMovies = [Movie]()
    let tmdbService = TheMovieDatabaseService()
    weak var delegate:MoviesTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        recommendedMovies = [Movie]()
        tableView.reloadData()
        for fav in ratings {
            if let similarMovies = fav.similarTheMovieDB {
                for similar in similarMovies {
                    let rating = 1/(Float(similarMovies.indexOf(similar)!)+1)
                    if let _ = recommendations[similar] {
                        recommendations[similar]! += rating
                    }
                    else {
                        recommendations[similar] = rating
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
            tmdbService.getMovie(id) {
                (movie) in
                if ratings.indexOf({ $0.idTheMovieDB == movie.idTheMovieDB }) < 0 {
                    self.recommendedMovies.append(movie)
                    movie.similarRating = rating
                    //update the tableView
                    self.tableView.beginUpdates()
                    let indexPath = NSIndexPath(forRow: self.recommendedMovies.count-1, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                }
            }
            i++
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
        let cell = tableView.dequeueReusableCellWithIdentifier("RecommendationsCell", forIndexPath: indexPath)
        
        let rec = recommendedMovies[indexPath.row]
        cell.textLabel?.text = "\(rec.title)"
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC =
            segue.destinationViewController as? MovieDetailViewController,
            cell = sender as? UITableViewCell,
            indexPath = self.tableView.indexPathForCell(cell),
            movie = recommendedMovies[indexPath.row] as Movie?{
                destVC.movie = movie
        }
    }

}
