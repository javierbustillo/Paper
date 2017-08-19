//
//  PostDetailViewController.swift
//  uprm1
//
//  Created by Javier Bustillo on 8/17/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse

class PostDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postText: UILabel!
    var comments: [PFObject]!
    var posts: [PFObject]!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        let post = posts![index!]
        postText.text = post["post"] as? String
        
        refreshData()
        
        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let comments = comments{
            return comments.count
        }
        else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        
        cell.comments = comments![indexPath.row]
        cell.selectionStyle = .none
        
        return cell
        
    }

    func refreshData(){
       
        let post = posts![index!]

        let query = PFQuery(className: "Comment")
        query.order(byDescending: "createdAt")
        
        query.limit = 20
        query.whereKey("originalID", equalTo: post.objectId!)
        
        query.findObjectsInBackground { (comments: [PFObject]?, error: Error?) in
            if let comments = comments{
                self.comments = comments
                self.tableView.reloadData()
                print("woo")
            } else {
                // handle error
                print("error")
                
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToCommenter"
            {
                let post = posts![index!]
                print(1)

                let originalID = post.objectId
                let commenterVC = segue.destination as! CommenterViewController
                
                commenterVC.originalID = originalID!
                
            }
        }

    }
    


