//
//  RatingsTableViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/25/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class RatingsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let smService = SimilarMoviesService()
    var filteredMovies = [Movie]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        // scope bar
        searchController.searchBar.scopeButtonTitles = ["All", "Favorite", "Like", "Okay", "Dislike"]
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.tableHeaderView = searchController.searchBar
        ratedMovies.sortInPlace({ $0.title < $1.title })
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if ratedMovies.count > 0 {
            tableView.separatorStyle = .SingleLine
            return 1
        }
        else {
            let noResults = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, 100))
            noResults.text = "No movies have been rated"
            noResults.textColor = UIColor.blackColor()
            noResults.textAlignment = .Center
            tableView.tableHeaderView = noResults
            tableView.separatorStyle = .None
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return filteredMovies.count
        }
        return ratedMovies.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RatingsCell", forIndexPath: indexPath) as! RatingsTableViewCell

        //let movie = ratedMovies[indexPath.row] as Movie
        let movie: Movie
        if searchController.active {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = ratedMovies[indexPath.row]
        }
        cell.movie = movie
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC =
            segue.destinationViewController as? MovieDetailTableViewController,
            cell = sender as? UITableViewCell,
            indexPath = self.tableView.indexPathForCell(cell){
                let movie: Movie
                if searchController.active {
                    movie = filteredMovies[indexPath.row]
                } else {
                    movie = ratedMovies[indexPath.row]
                }
                destVC.movie = movie
        }
    }
    
    // MARK - search functionality
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredMovies = ratedMovies.filter { movie in
            let categoryMatch = (scope == "All") || (movie.rating == Movie.Rating.Favorite && scope == "Favorite") || (movie.rating == Movie.Rating.Like && scope == "Like") || (movie.rating == Movie.Rating.Okay && scope == "Okay") || (movie.rating == Movie.Rating.Dislike && scope == "Dislike")
            let consoleMatch = (searchText == "") || movie.title.lowercaseString.containsString(searchText.lowercaseString)
            return  categoryMatch && consoleMatch
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
