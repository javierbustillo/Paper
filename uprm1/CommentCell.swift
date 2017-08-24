//
//  CommentCell.swift
//  uprm1
//
//  Created by Javier Bustillo on 8/18/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse
class CommentCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var upVote: UIButton!
    @IBOutlet weak var downVote: UIButton!
    @IBOutlet weak var stepsLabel: UILabel!
   
    var upVoted: Bool!
    var downVoted: Bool!
    var upVoters: [String]!
    var downVoters: [String]!
    let userName = PFUser.current()?.username
    
    var comments: PFObject!{
        didSet{
            commentLabel.text = comments["comment"] as? String
            dateLabel.text =  "\(returnTime(createdAt: comments.createdAt!))" as String
            stepsLabel.text = ("\(comments["steps"]!)")as String
            upVoters = comments["upVoters"] as! [String]?
            downVoters = comments["downVoters"] as! [String]?
            
            if upVoters.contains((userName)!){
                upVoted = true
                //change button
            }
            if downVoters.contains(userName!){
                downVoted = true
                //change button
            }

        }
    }
    
    func returnTime(createdAt : Date) -> String{
        let seconds = NSDate().timeIntervalSince(createdAt as Date)
        if(seconds < 60){
            return String("Just Now")
        }else{
            let minutes = Int(seconds/60)
            if(minutes > 59){
                let hours = Int(minutes/60)
                if hours > 23{
                    let days = Int(hours/24)
                    return String("\(days)d ago")
                }else{
                    return String("\(hours)h ago")
                }
            }else{
                return String("\(minutes)m ago")
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
