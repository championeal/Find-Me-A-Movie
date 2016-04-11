//
//  AddFavoritesViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/7/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class AddFavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var baseURL = "https://api-public.guidebox.com/v1.43/US/"
    var APIkey = "rK8nuMrG5dZYDqZZFfDb2QO8dk1ATzmB"
    let gb = GuideboxService(apikey: "rK8nuMrG5dZYDqZZFfDb2QO8dk1ATzmB")
    var movies = [Movie]()  // model for table view
    var resultJSON : String = "" {
        didSet {
            print("\(resultJSON)")
            //jsonOutputLabel.text = resultJSON
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func search(sender: UIButton) {
        if let searchTerm = searchTextField.text {
            gb.search(searchTerm) {
                (movies) in
                self.movies = movies
                self.tableView.reloadData()
            }
            /*var searchURL = baseURL+APIkey+"/search/movie/title/\(searchTerm)"
            searchURL = searchURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string: searchURL)
            let request = NSMutableURLRequest(URL: url!)
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                (data, responseText, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    let result = String(data: data!, encoding: NSASCIIStringEncoding)!
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.resultJSON = result
                        self.parseJSONResponse(data!)
                    })
                    
                }
            }
            task.resume()*/
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = movies[indexPath.row].title
        return cell
    }
    
    func parseJSONResponse( data : NSData ) -> Void {
        let json = JSON(data: data)
        movies.removeAll()
        for (_, movie) in json["results"] {   // using _ in place of key because I don't care about the key (actually the index)
            movies.append(Movie(id:movie["id"].intValue, title:movie["title"].stringValue))
        }
        tableView.reloadData()
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
