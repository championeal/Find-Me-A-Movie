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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mov = Movie(id:-1, title:"test")
        //let sim = ["tt0120338", "tt0903624", "tt0145487", "tt1170358", "tt0325980", "tt1298650", "tt1010048", "tt0371746", "tt0454876", "tt2310332", "tt0418279", "tt0480249"]
        let sim = ["17144", "212986", "140491"]
        mov.similarTheMovieDB = sim
        ratings.append(mov)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
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
        return ratings.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RatingsCell", forIndexPath: indexPath)
        
        let favorite = ratings[indexPath.row] as Movie
        cell.textLabel?.text = "\(favorite.title)"
        return cell
    }
}
