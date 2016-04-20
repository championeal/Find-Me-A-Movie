//
//  FavoritesTableViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    var recommendations = [String:Float]()
    var recommendedMovies = [Movie]()
    let tmdbService = TheMovieDatabaseService()
    weak var delegate:MoviesTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortedRecs = recommendations.sort{$0.1 > $1.1}
        print(sortedRecs)
        let movies = sortedRecs.map {return $0.0}
        for mov in movies {
            tmdbService.findMovieUsingIMDB(mov) {
                (movie) in
                self.recommendedMovies.append(movie)
                //update the tableView
                self.tableView.beginUpdates()
                let indexPath = NSIndexPath(forRow: self.recommendedMovies.count-1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.tableView.endUpdates()
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MoviesCell", forIndexPath: indexPath)
        
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
}

protocol MoviesTableViewDelegate: class {
    func getRecommendations() -> [String:Int]
}
