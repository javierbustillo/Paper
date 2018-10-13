//
//  ViewController.swift
//  uprm1
//
//  Created by Javier Bustillo on 8/17/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import MapKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    
    @objc var posts: [PFObject]!
    @objc var vote: [PFObject]!
    
    let url = "http://127.0.0.1:8000/"
    var coord: CLLocationCoordinate2D!
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        let refreshControl = UIRefreshControl()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        refreshControl.addTarget(self, action:#selector(refreshAction),for: UIControl.Event.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
        
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
        
        cell.upVote.tag = indexPath.row
        cell.downVote.tag = indexPath.row

        
        return cell
        
    }

    @IBAction func postButton(_ sender: Any) {
        
    }

    @objc func refreshAction(refreshControl: UIRefreshControl) {
        
        
    }
        
    
    func refreshData(point: PFGeoPoint){
        

    }
    
    func getPosts(coord: CLLocationCoordinate2D){
        let latitude = coord.latitude
        let longitude = coord.longitude
        let endpoint = "\(self.url)posts?latitude=\(latitude)&longitude=\(longitude)"
        
        Alamofire.request(endpoint, method: .get).responseJSON { (response) in
            //read response
        }
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        getPosts(coord: locValue)
        self.coord = locValue
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        manager.stopUpdatingLocation()
    }
    
    
    @IBAction func upVote(_ sender: UIButton) {
        var upVoters = self.posts[sender.tag].object(forKey: "upVoters") as! [String]
        var downVoters = self.posts[sender.tag].object(forKey: "downVoters") as! [String]
        let userName = PFUser.current()?.username
        if(upVoters.contains(userName!)){
            self.posts[sender.tag].incrementKey("steps", byAmount: -1)
            let ind = upVoters.index(of: userName!)
            upVoters.remove(at: ind!)
            self.posts[sender.tag].setObject(upVoters, forKey: "upVoters")
            
        }else if(!upVoters.contains(userName!) && !downVoters.contains(userName!)) {
            self.posts[sender.tag].incrementKey("steps")
            upVoters.append(userName!)
            self.posts[sender.tag].setObject(upVoters, forKey: "upVoters")

        }else if(downVoters.contains(userName!)){
            let ind = downVoters.index(of: userName!)
            downVoters.remove(at: ind!)
            upVoters.append(userName!)
            
            self.posts[sender.tag].setObject(upVoters, forKey: "upVoters")
            self.posts[sender.tag].setObject(downVoters, forKey: "downVoters")
            self.posts[sender.tag].incrementKey("steps", byAmount: 2)

        }
        self.posts[sender.tag].saveInBackground()
        self.tableView.reloadData()

        
    }
    @IBAction func downVote(_ sender: UIButton) {
        var upVoters = self.posts[sender.tag]["upVoters"] as! [String]
        var downVoters = self.posts[sender.tag]["downVoters"] as! [String]
        let userName = PFUser.current()?.username
        if(downVoters.contains(userName!)){
            let ind = downVoters.index(of: userName!)
            downVoters.remove(at: ind!)
            self.posts[sender.tag].setObject(downVoters, forKey: "downVoters")
            self.posts[sender.tag].incrementKey("steps")
            
        }else if(!downVoters.contains(userName!) && !upVoters.contains(userName!)) {
            downVoters.append(userName!)
            self.posts[sender.tag].setObject(downVoters, forKey: "downVoters")
            self.posts[sender.tag].incrementKey("steps", byAmount: -1)

        }else if(upVoters.contains(userName!)){
            let ind = upVoters.index(of: userName!)
            upVoters.remove(at: ind!)
            downVoters.append(userName!)
            
            self.posts[sender.tag].setObject(upVoters, forKey: "upVoters")
            self.posts[sender.tag].setObject(downVoters, forKey: "downVoters")
            self.posts[sender.tag].incrementKey("steps", byAmount: -2)
        }
        self.posts[sender.tag].saveInBackground()
        self.tableView.reloadData()


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
        
        if segue.identifier == "SegueToPoster"{
            let posterVC = segue.destination as! PosterViewController
            posterVC.coord = self.coord
        }
    }

}

