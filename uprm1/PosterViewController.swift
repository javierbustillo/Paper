//
//  PosterViewController.swift
//  uprm1
//
//  Created by Javier Bustillo on 8/17/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import Alamofire

class PosterViewController: UIViewController, UITextViewDelegate {

    var coord: CLLocationCoordinate2D!
    let url = "http://127.0.0.1:8000/"
    @IBOutlet weak var characterCountLabel: UILabel!
    
    @IBOutlet weak var postText: UITextView!
    var textFlag: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        postText.delegate = self
        
        postText.text = "Write your post here"
        postText.textColor = UIColor.lightGray
        textFlag=0
        characterCountLabel.text = ""

        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if postText.textColor == UIColor.lightGray {
            postText.text = nil
            postText.textColor = UIColor.black
            textFlag=textFlag+1
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if postText.text.isEmpty {
            postText.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        characterCountLabel.text = "\(postText.text.count)"
        if(postText.text!.count>140){
            characterCountLabel.textColor = UIColor.red
        }else{
            characterCountLabel.textColor = UIColor.black
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButton(_ sender: Any) {
        
        if(textFlag==0||postText.text.isEmpty){
            print("error should appear saying you need to write something")
        }
        else if(postText.text!.count>140){
            print("Less characters dude")
        }
        else{
            let endpoint = "\(url)posts/"
            
            let parameters = [
                "text": postText.text!,
                "posted_by": 1,
                "latitude": coord.latitude,
                "longitude": coord.longitude,
                ] as [String : Any]
            
            Alamofire.request(endpoint, method: .post, parameters: parameters).responseJSON { (response) in
                
            }
            

        }
        
        
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true) { 
            
        }
    }
    @IBAction func tap(_ sender: Any) {
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
