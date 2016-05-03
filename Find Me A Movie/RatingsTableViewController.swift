//
//  RatingsTableViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/25/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class RatingsTableViewController: UITableViewController {
    
    let smService = SimilarMoviesService()
    var filteredMovies = [Movie]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // scope bar
        searchController.searchBar.scopeButtonTitles = ["All", "Favorite", "Like", "Okay", "Dislike"]
        searchController.searchBar.delegate = self
        
        let mov = Movie()
        //let sim = ["tt0120338", "tt0903624", "tt0145487", "tt1170358", "tt0325980", "tt1298650", "tt1010048", "tt0371746", "tt0454876", "tt2310332", "tt0418279", "tt0480249"]
        let sim = ["17144", "212986", "140491"]
        mov.similarTheMovieDB = sim
        ratedMovies.append(mov)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        ratedMovies.sortInPlace({ $0.title < $1.title })
        tableView.reloadData()
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
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredMovies = ratedMovies.filter { movie in
            let categoryMatch = (scope == "All") || (movie.rating == Movie.Rating.Favorite && scope == "Favorite") || (movie.rating == Movie.Rating.Like && scope == "Like") || (movie.rating == Movie.Rating.Okay && scope == "Okay") || (movie.rating == Movie.Rating.Dislike && scope == "Dislike")
            let consoleMatch = (searchText == "") || movie.title.lowercaseString.containsString(searchText.lowercaseString)
            return  categoryMatch && consoleMatch
        }
        
        tableView.reloadData()
    }
}

extension RatingsTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension RatingsTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
