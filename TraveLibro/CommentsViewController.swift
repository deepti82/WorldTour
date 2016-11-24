//
//  CommentsViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/27/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    var postId = ""
    var comments: [JSON] = []
    var otherId = ""
    var hashtags: [String] = []
    var mentions: [String] = []
    var suggestionFor = "hashtag"
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var addComment: UITextView!
    @IBAction func sendComment(_ sender: UIButton?) {
        
        print("inside send comments")
        addComment.resignFirstResponder()
        let commentText = addComment.text.components(separatedBy: " ")
        print("comment text: \(commentText)")
        for eachText in commentText {
            if eachText.contains("#") {
                hashtags.append(eachText)
            }
            else if eachText.contains("@") {
                mentions.append(eachText)
            }
        }
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
        addComment.delegate = self
        
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
    
    func textViewDidChange(textView: UITextView) {
        
        if textView.text.contains("#") {
            container.alpha = 1
            suggestionFor = "hashtag"
            
        }
        else if textView.text.contains("@") {
            container.alpha = 1
            suggestionFor = "mentions"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myEmbeddedSegue") {
            let childViewController = segue.destination as! SuggestionsViewController
            childViewController.whichSuggestion = suggestionFor
            let commentText = addComment.text.components(separatedBy: " ")
            childViewController.textVar = commentText.last!
        }
    }
    
    func setAllComments(_ comment: String) {
        
        request.commentOnPost(id: postId, postId: otherId, userId: currentUser["_id"].string!, commentText: comment, userName: currentUser["name"].string!, hashtags: hashtags, mentions: mentions, completion: {(response) in
            
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
        
        cell.profileComment.customize {label in
            label.handleMentionTap {
                
                let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Mention", message: $0, preferredStyle: .alert)
                let cancelActionButton: UIAlertAction = UIAlertAction(title: "OK", style: .default) {action -> Void in}
                actionSheetControllerIOS8.addAction(cancelActionButton)
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
            label.handleHashtagTap {
                
                let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Hashtag", message: $0, preferredStyle: .alert)
                let cancelActionButton: UIAlertAction = UIAlertAction(title: "OK", style: .default) {action -> Void in}
                actionSheetControllerIOS8.addAction(cancelActionButton)
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
            label.handleURLTap { let actionSheetControllerIOS8: UIAlertController =
                
                UIAlertController(title: "Url", message: "\($0)", preferredStyle: .alert)
                let cancelActionButton: UIAlertAction = UIAlertAction(title: "OK", style: .default) {action -> Void in}
                actionSheetControllerIOS8.addAction(cancelActionButton)
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
        }
        
        return cell
        
    }
    

}

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileComment: ActiveLabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var calendarText: UILabel!
    @IBOutlet weak var clockText: UILabel!
    
}
