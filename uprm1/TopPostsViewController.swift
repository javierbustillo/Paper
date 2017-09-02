//
//  TopPostsViewController.swift
//  uprm1
//
//  Created by Javier Bustillo on 9/2/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse

class TopPostsViewController: UIViewController {
    
    var posts: [PFObject]!


    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(){
        let query = PFQuery(className: "Post")
        
        query.order(byDescending: "steps")
       // query.whereKey("locat", nearGeoPoint: point, withinMiles:5)
        query.limit = 20
        query.whereKey("createdAt", greaterThan: SYSTEM_CLOCK-172800)
        
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts{
                self.posts = posts
                //self.tableView.reloadData()
                print("woo")
                print(posts.count)
                print(posts[0]["post"])
                print(SYSTEM_CLOCK)
            } else {
                // handle error
                print("error")
                
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
