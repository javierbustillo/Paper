//
//  Comment.swift
//  uprm1
//
//  Created by Javier Bustillo on 8/18/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse

class Comment: NSObject {

    @objc var comment: String?
    var steps: Int?
    @objc var originalID: String?
    @objc var upVoters: [String]? = []
    @objc var downVoters: [String]? = []
    @objc var user: String?
    
    @objc init(comment: String, steps: Int, originalID: String, user: String){
        self.comment = comment
        self.steps=0
        self.originalID=originalID
        self.user = user
    }
    
    @objc func poster(){
        let comment = PFObject(className: "Comment")
        comment.setObject(self.comment!, forKey: "comment")
        comment.setObject(steps!, forKey: "steps")
        comment.setObject(originalID!, forKey: "originalID")
        comment.setObject(upVoters!, forKey: "upVoters")
        comment.setObject(downVoters!, forKey: "downVoters")
        comment.setObject(user!, forKey: "user")
        
        comment.saveInBackground { (success: Bool, error: Error?) in
            if(success){
                print("posted!")
            }
            else{
                print("failure")
            }
        }

    }
}
