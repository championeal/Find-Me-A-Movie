//
//  AddFavoritesViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/7/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class AddFavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddFavoritesTableViewCellDelegate {
    var baseURL = "https://api-public.guidebox.com/v1.43/US/"
    let gb = GuideboxService()
    var movies = [Movie]()  // model for table view
    var favorites = [Movie]() // array for temp persistence
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func search(sender: UIButton) {
        if let searchTerm = searchTextField.text {
            movies.removeAll()
            gb.searchMovies(searchTerm) {
                (movies) in
                self.movies = movies
                for movie in self.movies {
                    if let _ = self.favorites.indexOf ({ $0.id == movie.id })
                    {
                        movie.favorite = true
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddFavoritesCell", forIndexPath: indexPath) as! AddFavoritesTableViewCell
        
        let movie = movies[indexPath.row] as Movie
        cell.movie = movie
        cell.delegate = self
        return cell
    }
    
    
    func addFavorite(movie: Movie){
        favorites.append(movie)
    }
    
    func removeFavorite(movie: Movie){
        favorites.removeAtIndex(favorites.indexOf({ $0.id == movie.id })!)
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
}
