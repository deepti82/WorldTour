//
//  CommentsViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/27/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var postId = ""
    var comments: [JSON] = []
    var otherId = ""
    
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var addComment: UITextView!
    @IBAction func sendComment(sender: UIButton?) {
        
        print("inside send comments")
        addComment.resignFirstResponder()
        setAllComments(addComment.text)
        addComment.text = ""
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        getAllComments()
        commentsTable.tableFooterView = UIView()
        commentsTable.estimatedRowHeight = 70.0
        commentsTable.rowHeight = UITableViewAutomaticDimension
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        addComment.returnKeyType = .Done
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        addComment.resignFirstResponder()
        sendComment(nil)
        return true
        
    }
    
    func setAllComments(comment: String) {
        
        request.commentOnPost(postId, userId: currentUser["_id"].string!, commentText: comment, userName: currentUser["name"].string!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    self.getAllComments()
                }
                else {
                    
                    
                }
                
            })
            
        })
        
    }
    
    func getAllComments() {
        
        request.getComments(otherId, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    self.comments = response["data"]["comment"].array!
                    self.commentsTable.reloadData()
                    
                }
                else {
                    
                    
                }
                
            })
            
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CommentTableViewCell
        cell.profileName.text = comments[indexPath.row]["user"]["name"].string!
        cell.profileComment.text = comments[indexPath.row]["text"].string!
        cell.profileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(comments[indexPath.row]["user"]["profilePicture"])&width=100")!)!)
        makeTLProfilePicture(cell.profileImage)
        return cell
        
    }
    

}

class CommentTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var profileImage: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileComment: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
}
