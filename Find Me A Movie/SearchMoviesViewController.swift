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
    var searchedMovies = [Movie]()
    var search = false
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func search(sender: UIButton) {
        search = true
        if let searchTerm = searchTextField.text {
            searchedMovies.removeAll()
            tmdbService.searchMovies(searchTerm) {
                (movies) in
                self.searchedMovies = movies
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
        if searchedMovies.count > 0 || search == false{
            tableView.tableHeaderView = nil
            tableView.separatorStyle = .SingleLine
            return 1
        }
        else {
            let noResults = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, 100))
            noResults.text = "No search results found"
            noResults.textColor = UIColor.blackColor()
            noResults.textAlignment = .Center
            tableView.tableHeaderView = noResults
            tableView.separatorStyle = .None
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMovies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchMoviesTableViewCell", forIndexPath: indexPath) as! SearchMoviesTableViewCell
        let movie = searchedMovies[indexPath.row] as Movie
        cell.movie = movie
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC =
            segue.destinationViewController as? MovieDetailTableViewController,
            cell = sender as? UITableViewCell,
            indexPath = self.tableView.indexPathForCell(cell),
            movie = searchedMovies[indexPath.row] as Movie?{
                destVC.movie = movie
        }
    }

}
