//
//  GetStreamsViewController.swift
//  Find Me A Movie
//
//  Created by Neal Sheehan on 4/6/16.
//  Copyright © 2016 Neal Sheehan. All rights reserved.
//

import UIKit

class GetStreamsViewController: UIViewController {

    var APIurl = "https://api-public.guidebox.com/v1.43/US/"
    var APIkey = "rK8nuMrG5dZYDqZZFfDb2QO8dk1ATzmB"
    var movieID: Int?
    var resultJSON : String = "" {
        didSet {
            //print("\(resultJSON)")
        }
    }
    var streams = [Stream]()
    var streams_string = ""
    
    @IBOutlet weak var subscriptionStreamsLabel: UILabel!
    @IBOutlet weak var freeStreamsLabel: UILabel!
    @IBOutlet weak var StreamsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveStreams(21596)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func parseJSONResponse( data : NSData ) -> Void {
        let json = JSON(data: data)
        //print(json["purchase_web_sources"])
        for (_,source) in json["tv_everywhere_web_sources"] {   // using _ in place of key
            streams_string = streams_string + "\(source["display_name"]) - \(source["tv_channel"])\n"
        }
        freeStreamsLabel.text = streams_string
        streams_string = ""
        for (_,source) in json["subscription_web_sources"] {   // using _ in place of key
            streams_string = streams_string + "\(source["display_name"])\n"
        }
        subscriptionStreamsLabel.text = streams_string
        streams_string = ""
        for (_,source) in json["purchase_web_sources"] {   // using _ in place of key
            streams_string = streams_string + "\(source["display_name"]) - \(source["formats"][0]["format"]) - \(source["formats"][0]["price"])\n"
        }
        StreamsLabel.text = streams_string
        streams_string = ""
    }

    func retrieveStreams(movieID: Int) {
        
            let url = NSURL(string: APIurl+APIkey+"/movie/\(movieID)")
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
            task.resume()
    }

}

class Stream {
    var name:String
    var type:String
    var price:String
    
    init(name:String, type:String, price:String){
        self.name = name
        self.type = type
        self.price = price
    }
}