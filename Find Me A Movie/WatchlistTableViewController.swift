//
//  WatchlistTableViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 5/2/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class WatchlistTableViewController: UITableViewController {

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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    func filterContentForSearchText(searchText: String, scope: String = "Watchlist") {
        filteredMovies = listedMovies.filter { movie in
            let categoryMatch = (movie.list == Movie.List.Watchlist && scope == "Watchlist") || (movie.list == Movie.List.NotInterested && scope == "Not Interested")
            let consoleMatch = (searchText == "") || movie.title.lowercaseString.containsString(searchText.lowercaseString)
            return  categoryMatch && consoleMatch
        }
        tableView.reloadData()
    }
}

extension WatchlistTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension WatchlistTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
