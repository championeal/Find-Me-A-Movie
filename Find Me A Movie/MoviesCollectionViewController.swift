//
//  MoviesCollectionViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/12/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class MoviesCollectionViewController: UICollectionViewController {
    
    var recommendations = [String:Int]()
    var recommendedMovies = [Movie]()
    let tmdbService = TheMovieDatabaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (key,_) in recommendations {
            tmdbService.findMovieUsingIMDB(key) {
                (movie) in
                self.recommendedMovies.append(movie)
                //update the tableView
                let indexPath = NSIndexPath(forRow: self.recommendedMovies.count-1, inSection: 0)
                self.collectionView!.insertItemsAtIndexPaths([indexPath])
            }
        }
        //if let patternImage = UIImage(named: "Pattern") {
        //    view.backgroundColor = UIColor(patternImage: patternImage)
        //}
        //collectionView!.backgroundColor = UIColor.clearColor()
        //collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedMovies.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        let movie = recommendedMovies[indexPath.row] as Movie
        cell.movie = movie
        return cell
    }
    
}
