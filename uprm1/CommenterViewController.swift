//
//  CommenterViewController.swift
//  uprm1
//
//  Created by Javier Bustillo on 8/18/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse

class CommenterViewController: UIViewController,UITextViewDelegate {
   
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var textFlag: Int!
    var originalID: String!


    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        textView.text = "Write your post here"
        textView.textColor = UIColor.lightGray
        textFlag=0
        characterCountLabel.text = ""
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textFlag=textFlag+1
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        characterCountLabel.text = "\(textView.text.count)"
        if(textView.text!.count>140){
            characterCountLabel.textColor = UIColor.red
        }else{
            characterCountLabel.textColor = UIColor.black
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true) { 
            
        }
    }
    @IBAction func postButton(_ sender: Any) {
        if(textFlag==0||textView.text.isEmpty){
            print("error should appear saying you need to write something")
        }
        else if(textView.text!.count>140){
            print("Less characters dude")
        }
        else{
            let userName = PFUser.current()?.username
            let thisComment = Comment(comment: self.textView.text, steps: 0, originalID: originalID, user: userName!)
            thisComment.poster()
            view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)

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
