//
//  GetSimilarMoviesViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/11/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class GetSimilarMoviesViewController: UIViewController {

    let sm = SimilarMoviesService()
    let tmdbService = TheMovieDatabaseService()
    var bestMovies = [String:Int]()
    var movies = [String]()
    let ids = ["tt1045658","tt0420223","tt2395427","tt0478970","tt0169547"]
    let tmdbURL = "https://www.themoviedb.org/movie/"
    let tmdbID = "550"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var movies = [String]()
        if let url = NSURL(string:tmdbURL+tmdbID+"/recommended") {
            if let doc = HTML(url: url, encoding: NSUTF8StringEncoding){
                //print(doc.title!+"\n")
                print(doc.title!)
                // Search for nodes by XPath
                for href in doc.xpath("//tr/td/a/@href"){
                    let text = href.text!
                    let index = text.startIndex.advancedBy(7)
                    let id = text.substringFromIndex(index)
                    print(id)
                    movies.append(id)
                }
                //for title in doc.xpath("//div[@class='rec-title']/a") {
                //    print(title.text!)
                //}
                /*for id in doc.xpath("//div[@class='rec_poster']") {
                    movies.append(id["data-tconst"]!)
                }
                dispatch_async(GlobalMainQueue, {
                    callback(movies)
                })*/
            }
        }
        tmdbService.getMovie(movies[0]){
            (movie) in
            print(movie.title)
        }
        
        //Movie - Silver Linings Playbook
        
        //IMDB
        /*var count = 1;
        for id in ids {
            print("Loading: \(count)")
            movies = sm.getIMDB(id)
            for movie in movies {
                if let _ = bestMovies[movie] {
                    bestMovies[movie]! += 1
                }
                else {
                    bestMovies[movie] = 1
                }
            }
            count++
        }
        print(bestMovies)
        let moviesArray = bestMovies.sort{ $0.1 > $1.1 }
        
        for (movie,count) in moviesArray {
            print(movie,count)
        }*/
        
        // Rotten Tomatoes
        /*let rtID = 771253886;
        let rtURL = "http://www.rottentomatoes.com/m/"
        var fullURL = rtURL+"\(rtID)"
        fullURL = "http://www.rottentomatoes.com/m/silver_linings_playbook/"
        if let url = NSURL(string:fullURL) {
            if let doc = HTML(url: url, encoding: NSUTF8StringEncoding) {
                print(doc.title)
                print(doc)
                
                // Search for nodes by XPath
                for title in doc.xpath("//div[@class='recItem']//p") {
                    print(title.text)
                }
            }
            print("this is garbage")
        }*/
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
