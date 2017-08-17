//
//  TableViewCell.swift
//  uprm1
//
//  Created by Javier Bustillo on 8/17/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse
class TableViewCell: UITableViewCell {

    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var posts: PFObject!{
        didSet{
            
            postLabel.text = posts["post"] as? String
            dateLabel.text = "\(returnTime(createdAt: posts.createdAt!))" as String
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

