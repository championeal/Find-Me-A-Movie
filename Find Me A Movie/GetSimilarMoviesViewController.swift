//
//  GetSimilarMoviesViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class GetSimilarMoviesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Movie - Silver Linings Playbook
        
        //IMDB
        let imdbID = "tt1045658"
        let imdbURL = "http://www.imdb.com/title/"
        if let url = NSURL(string:imdbURL+imdbID) {
            if let doc = HTML(url: url, encoding: NSUTF8StringEncoding) {
                print(doc.title!+"\n")
                
                // Search for nodes by XPath
                for title in doc.xpath("//div[@class='rec-title']/a") {
                    print(title.text)
                }
                for id in doc.xpath("//div[@class='rec_poster']") {
                    print(id["data-tconst"])
                }
            }
        }
        
        // Rotten Tomatoes
        let rtID = 771253886;
        let rtURL = "http://www.rottentomatoes.com/m/"
        var fullURL = rtURL+"\(rtID)"
        fullURL = "http://www.rottentomatoes.com/m/silver_linings_playbook/"
        if let url = NSURL(string:fullURL) {
            if let doc = HTML(url: url, encoding: NSUTF8StringEncoding) {
                print(doc.title)
                
                // Search for nodes by XPath
                for title in doc.xpath("//div[@class='recItem']//p") {
                    print(title.text)
                }
            }
            print("this is garbage")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
