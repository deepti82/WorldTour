//
//  PhotoCommentViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 25/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PhotoCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    var postId = ""
    var comments: [JSON] = []
    var otherId = ""
    var hashtags: [String] = []
    var mentions: [String] = []
    var mentionSuggestions: [JSON] = []
    var hashtagSuggestions: [JSON] = []
    var previousHashtags: [String] = []
    var editComment: JSON!
    
    @IBOutlet weak var commentTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllComments()
        commentTableView.tableFooterView = UIView()
        commentTableView.estimatedRowHeight = 80.0
        commentTableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoCommentViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoCommentViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addComment.returnKeyType = .done
        addComment.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var removedHashtags: [String] = []
    var addedHashtags: [String] = []
    var isEdit = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 2:
            return mentionSuggestions.count
        case 1:
            return hashtagSuggestions.count
        default:
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView.tag {
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTwo") as! PhotoMentionSuggestionsTableViewCell
            cell.titleLabel.text = mentionSuggestions[indexPath.row]["urlSlug"].string!
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SuggestionsTableViewCell
            cell.titleLabel.text = hashtagSuggestions[indexPath.row]["title"].string!
            cell.statistics.text = "\(hashtagSuggestions[indexPath.row]["count"])"
            return cell
        default:
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
                //                label.text =
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if self.comments[indexPath.row]["user"]["_id"].string! == currentUser["_id"].string! {
            
            let more = UITableViewRowAction(style: .normal, title: "            ") { action, index in
                print("edit button tapped")
                
                self.addComment.text = self.comments[indexPath.row]["text"].string!
                self.previousHashtags = self.getHashtagsFromText(oldText: self.comments[indexPath.row]["text"].string!)
                self.editComment = self.comments[indexPath.row]
                self.isEdit = true
                
            }
            //more.backgroundColor = UIColor.lightGray
            let moreImage = UIImageView(image: UIImage(named: "edit.png"))
            moreImage.contentMode = .scaleAspectFit
            more.backgroundColor = UIColor(patternImage: moreImage.image!)
            
            let favorite = UITableViewRowAction(style: .normal, title: "            ") { action, index in
                print("delete button tapped")
                request.deleteComment(commentId: self.comments[indexPath.row]["_id"].string!, completion: {(response) in
                    
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
            let favoriteImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 80))
            favoriteImage.image = UIImage(named: "delete.png")
            favoriteImage.contentMode = .scaleAspectFit
            favorite.backgroundColor = UIColor(patternImage: favoriteImage.image!)
            
            return [more, favorite]
        }
            
        else {
            
            let share = UITableViewRowAction(style: .normal, title: "           ") { action, index in
                print("reply button tapped")
                
                let userTag = "@\(self.comments[indexPath.row]["user"]["urlSlug"].string!)"
                self.addComment.text = userTag
                
            }
            share.backgroundColor = UIColor(patternImage: UIImage(named: "reply")!)
            
            let report = UITableViewRowAction(style: .normal, title: "          ") { action, index in
                print("report button tapped")
                let actionSheet: UIAlertController = UIAlertController(title: "Why are you reporting this comment?", message: nil, preferredStyle: .actionSheet)
                //actionSheet.view.tintColor = UIColor.red
                
                let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                    print("Cancel")
                }
                actionSheet.addAction(cancelActionButton)
                
                let spamActionButton: UIAlertAction = UIAlertAction(title: "Spam or Scam", style: .default) { action -> Void in
                    print("Spam or Scam")
                }
                
                actionSheet.addAction(spamActionButton)
                
                let abusiveActionButton: UIAlertAction = UIAlertAction(title: "Abusive Content", style: .default) { action -> Void in
                    print("Abusive Content")
                }
                actionSheet.addAction(abusiveActionButton)
                self.present(actionSheet, animated: true, completion: nil)
            }
            report.backgroundColor = UIColor(patternImage: UIImage(named: "report")!)
            
            return [share, report]
        }
        
    }
    
    func getHashtagsFromText(oldText: String) -> [String] {
        
        var hashtags: [String] = []
        
        let oldTextArray = oldText.components(separatedBy: " ")
        
        for word in oldTextArray {
            
            if word.contains("#") {
                hashtags.append(word)
            }
            
        }
        
        return hashtags
    }
    
    var textVar = ""
    
    func textViewDidChange(_ textView: UITextView) {
        
        let commentText = textView.text.components(separatedBy: " ")
        textVar = commentText.last!
        container.alpha = 0
        containerTwo.alpha = 0
        
        if textVar.contains("#") {
            hashTagSuggestionsTable.isHidden = false
            mentionSuggestionsTable.isHidden = true
            getHashtags()
            print("hashtag in text")
            //            container.alpha = 1
            //            containerTwo.alpha = 0
            //            performSegue(withIdentifier: "myEmbeddedSegue", sender: nil)
        }
        else if textVar.contains("@") {
            
            textVar = String(textVar.characters.dropFirst())
            mentionSuggestionsTable.isHidden = false
            hashTagSuggestionsTable.isHidden = true
            getMentions()
            print("mentions in text")
            //            suggestionFor = "mentions"
            //            containerTwo.alpha = 1
            //            container.alpha = 0
            //            performSegue(withIdentifier: "myEmbeddedSegueTwo", sender: nil)
        } else {
            hashTagSuggestionsTable.isHidden = true
            mentionSuggestionsTable.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView.tag {
        case 2:
            mentionSuggestionsTable.isHidden = true
            let cell = mentionSuggestionsTable.cellForRow(at: indexPath) as! PhotoMentionSuggestionsTableViewCell
            mentions.append(mentionSuggestions[indexPath.row]["_id"].string!)
            modifyText(textView: addComment, modifiedString: cell.titleLabel.text!, replacableString: textVar)
        case 1:
            hashTagSuggestionsTable.isHidden = true
            let cell = hashTagSuggestionsTable.cellForRow(at: indexPath) as! SuggestionsTableViewCell
            modifyText(textView: addComment, modifiedString: cell.titleLabel.text!, replacableString: textVar)
        default:
            break
        }
        
    }
    
    func modifyText(textView: UITextView, modifiedString: String, replacableString: String) {
        
        if replacableString == "" {
            textView.text = "\(textView.text!)\(modifiedString)"
        } else {
            let myString = textView.text as NSString
            textView.text = myString.replacingOccurrences(of: replacableString, with: modifiedString)
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myEmbeddedSegue") {
            print("hashtag segue")
            let childViewController = segue.destination as! SuggestionsViewController
            childViewController.getSuggestions()
            let commentText = addComment.text.components(separatedBy: " ")
            childViewController.textVar = commentText.last!
        }
        else if (segue.identifier == "myEmbeddedSegueTwo") {
            print("mention segue")
            let childViewController = segue.destination as! MentionSuggestionsViewController
            //            childViewController.getMentions()
            let commentText = addComment.text.components(separatedBy: " ")
            childViewController.textVar = commentText.last!
        }
    }
    
    func getMentions() {
        
        request.getMentions(userId: currentUser["_id"].string!, searchText: textVar, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.mentionSuggestions = response["data"].array!
                    self.mentionSuggestionsTable.reloadData()
                    
                }
                else {
                    
                    
                }
                
            })
            
        })
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
                    self.commentTableView.reloadData()
                    
                }
                else {
                    
                    
                }
                
            })
            
        })
        
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

class PhotoCommentCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileComment: UILabel!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var calendarText: UILabel!
    @IBOutlet weak var clockText: UILabel!
    
}

class PhotoMentionTableViewCell: UITableViewCell {
    
}

class PhotoSuggestionsTableViewCell: UITableViewCell {
    
}
