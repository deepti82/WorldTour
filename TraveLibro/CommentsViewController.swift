//
//  CommentsViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/27/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var postId = ""
    var comments: [JSON] = []
    var otherId = ""
    
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var addComment: UITextView!
    @IBAction func sendComment(_ sender: UIButton?) {
        
        print("inside send comments")
        addComment.resignFirstResponder()
        setAllComments(addComment.text)
        addComment.text = ""
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        getAllComments()
        commentsTable.tableFooterView = UIView()
        commentsTable.estimatedRowHeight = 80.0
        commentsTable.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addComment.returnKeyType = .done
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        addComment.resignFirstResponder()
        sendComment(nil)
        return true
        
    }
    
    func setAllComments(_ comment: String) {
        
        request.commentOnPost(postId, postId: otherId, userId: currentUser["_id"].string!, commentText: comment, userName: currentUser["name"].string!, hashtags: [], completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.getAllComments()
                }
                else {
                    
                    
                }
                
            })
            
        })
        
    }
    
    func getAllComments() {
        
        request.getComments(otherId, userId: currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.comments = response["data"]["comment"].array!
                    self.commentsTable.reloadData()
                    
                }
                else {
                    
                    
                }
                
            })
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CommentTableViewCell
        cell.profileName.text = comments[indexPath.row]["user"]["name"].string!
        cell.profileComment.text = comments[(indexPath as NSIndexPath).row]["text"].string!
        DispatchQueue.main.async(execute: {
            cell.profileImage.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(self.comments[indexPath.row]["user"]["profilePicture"])&width=100")!))
            makeTLProfilePicture(cell.profileImage)
        })
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let date = dateFormatter.date(from: comments[indexPath.row]["createdAt"].string!)
        dateFormatter.dateFormat = "dd MMM, yyyy"
        timeFormatter.dateFormat = "hh:mm a"
        cell.calendarText.text = "\(dateFormatter.string(from: date!))"
        cell.clockText.text = "\(timeFormatter.string(from: date!))"
        cell.clockIcon.text = String(format: "%C", faicon["clock"]!)
        cell.calendarIcon.text = String(format: "%C", faicon["calendar"]!)
        
        return cell
        
    }
    

}

class CommentTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var profileImage: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileComment: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var calendarText: UILabel!
    @IBOutlet weak var clockText: UILabel!
    
}
