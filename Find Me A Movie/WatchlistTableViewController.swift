//
//  WatchlistTableViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 5/2/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class WatchlistTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var filteredMovies = [Movie]()
    var watchlist = [Movie]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // scope bar
        searchController.searchBar.scopeButtonTitles = ["Watchlist", "Not Interested"]
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        listedMovies.sortInPlace({ $0.title < $1.title })
        watchlist = listedMovies.filter { movie in
            return movie.list == Movie.List.Watchlist
        }
        watchlist.sortInPlace({ $0.title < $1.title })
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if watchlist.count > 0 {
            tableView.tableHeaderView = nil
            tableView.separatorStyle = .SingleLine
            return 1
        }
        else {
            let noResults = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, 100))
            noResults.text = "No movies in watchlist"
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
        return watchlist.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("watchlistCell", forIndexPath: indexPath) as! WatchlistTableViewCell
        
        let movie: Movie
        if searchController.active {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = watchlist[indexPath.row]
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
                    movie = watchlist[indexPath.row]
                }
                destVC.movie = movie
        }
    }

    // MARK - search functionality
    
    func filterContentForSearchText(searchText: String, scope: String = "Watchlist") {
        filteredMovies = listedMovies.filter { movie in
            let categoryMatch = (movie.list == Movie.List.Watchlist && scope == "Watchlist") || (movie.list == Movie.List.NotInterested && scope == "Not Interested")
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
