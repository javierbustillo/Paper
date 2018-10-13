//
//  Post.swift
//  uprm1
//
//  Created by Javier Bustillo on 8/17/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    @objc var post: String?
    var steps: Int?
    @objc var locat: PFGeoPoint?
    @objc var upVoters: [String]? = []
    @objc var downVoters: [String]? = []
    @objc var user: String?
    
    @objc init(post: String, steps: Int, locat: PFGeoPoint, user: String){
        self.post = post
        self.steps = 0
        self.locat = locat
        self.user = user
    }
    
    @objc func poster(){
        let post = PFObject(className: "Post")
        
        post.setObject(self.post!, forKey: "post")
        post.setObject(steps!, forKey: "steps")
        post.setObject(locat!, forKey: "locat")
        post.setObject(upVoters!, forKey: "upVoters")
        post.setObject(downVoters!, forKey: "downVoters")
        post.setObject(user!, forKey: "user")
        
        
        post.saveInBackground { (success: Bool, error: Error?) in
            if(success){
                print("posted!")
            }
            else{
                print(error?.localizedDescription as Any)
            }
        }
    
    }
    

}
