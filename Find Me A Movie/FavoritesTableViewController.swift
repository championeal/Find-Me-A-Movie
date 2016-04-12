//
//  FavoritesTableViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    var favorites = [Movie]()
    var favoriteIDs = [Int]()
    let gb = GuideboxService()
    let sm = SimilarMoviesService()
    @IBAction func organizeFavorites(sender: UIBarButtonItem) {
        favorites.sortInPlace({ $0.title < $1.title })
        tableView.reloadData()
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoritesCell", forIndexPath: indexPath)

        let favorite = favorites[indexPath.row] as Movie
        cell.textLabel?.text = "\(favorite.title)"
        if favorite.similarIMDB == nil {
            if let id = favorite.idIMDB {
                self.sm.getIMDB(id) {
                    (similarMovies) in
                    favorite.similarIMDB = similarMovies
                }
            }
        }
        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navVC =
            segue.destinationViewController as? UINavigationController,
            destVC = navVC.topViewController as? AddFavoritesViewController{
                destVC.favorites = favorites
        }
    }

    
    // Mark Unwind Segues
    @IBAction func cancelToFavoritesViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveFavorites(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? AddFavoritesViewController {
            //reset old array & table view
            favorites.removeAll()
            tableView.reloadData()
            // add new favorites
            for fav in vc.favorites {
                self.favorites.append(fav)
                //update the tableView
                let indexPath = NSIndexPath(forRow: self.favorites.count-1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }


}
