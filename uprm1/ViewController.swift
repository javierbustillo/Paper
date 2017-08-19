//
//  ViewController.swift
//  uprm1
//
//  Created by Javier Bustillo on 8/17/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var posts: [PFObject]!

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        PFGeoPoint.geoPointForCurrentLocation { (point:PFGeoPoint?, error:Error?) in
            if((error) != nil){
                print(error?.localizedDescription)
            }else{
                self.refreshData(point: point!)
                self.tableView.reloadData()

            }
        }

        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action:#selector(refreshAction),for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PFGeoPoint.geoPointForCurrentLocation { (point:PFGeoPoint?, error:Error?) in
            if((error) != nil){
                print(error?.localizedDescription)
                print("WHAT")
            }else{
                self.refreshData(point: point!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let posts = posts{
            return posts.count
        }
        else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.posts = posts![indexPath.row]
        cell.selectionStyle = .none
        
        return cell
        
    }

    @IBAction func postButton(_ sender: Any) {
        
    }

    func refreshAction(refreshControl: UIRefreshControl) {
        
        PFGeoPoint.geoPointForCurrentLocation { (point:PFGeoPoint?, error:Error?) in
            if((error) != nil){
                print(error?.localizedDescription)
            }else{
                let url = NSURL(self.refreshData(point: point!))
                let request = URLRequest(url: url as URL)
                
                
                let session = URLSession(
                    configuration: URLSessionConfiguration.default,
                    delegate:nil,
                    delegateQueue:OperationQueue.main
                )
                
                let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (data, response, error) in
                    
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                });
                task.resume()

                
            }
        }
        
           }
    func refreshData(point: PFGeoPoint){
       
        
        
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.whereKey("locat", nearGeoPoint: point, withinMiles: 2)
        query.limit = 20
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts{
                self.posts = posts
                self.tableView.reloadData()
                print("woo")
            } else {
                // handle error
                print("error")
                
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        
        
        if segue.identifier == "SegueToDetail"
        {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            let index = indexPath!.row
            
            
            let postDetailVC = segue.destination as! PostDetailViewController
            
            postDetailVC.posts = posts
            postDetailVC.index = index
            
        }
    }

}

