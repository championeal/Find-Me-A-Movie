//
//  SearchMoviesViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/21/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class SearchMoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tmdbService = TheMovieDatabaseService()
    var movies = [Movie]()  // model for table view
    var favorites = [Movie]() // array for temp persistence
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func search(sender: UIButton) {
        if let searchTerm = searchTextField.text {
            movies.removeAll()
            tmdbService.searchMovies(searchTerm) {
                (movies) in
                self.movies = movies
                /*for movie in self.movies {
                    if let _ = self.favorites.indexOf ({ $0.id == movie.id })
                    {
                        movie.favorite = true
                    }
                }*/
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchMoviesTableViewCell", forIndexPath: indexPath) as! SearchMoviesTableViewCell
        let movie = movies[indexPath.row] as Movie
        cell.movie = movie
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC =
            segue.destinationViewController as? MovieDetailTableViewController,
            cell = sender as? UITableViewCell,
            indexPath = self.tableView.indexPathForCell(cell),
            movie = movies[indexPath.row] as Movie?{
                destVC.movie = movie
        }
    }

}
