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
    var photoId = ""
    var hashtags: [String] = []
    var mentions: [String] = []
    var mentionSuggestions: [JSON] = []
    
    var type = "Photo"
    
    var commentText: UILabel!
    
    var hashtagSuggestions: [JSON] = []
    var previousHashtags: [String] = []
    var addComment: JSON!
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var mentionTableView: UITableView!
    @IBOutlet weak var hashtagTableView: UITableView!

    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var editComment: UITextView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loader.showOverlay(self.view)
        setTopNavigation("Comment")
        
        getAllComments()
        commentTableView.tableFooterView = UIView()
        commentTableView.estimatedRowHeight = 80.0
        commentTableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoCommentViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoCommentViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        editComment.returnKeyType = .done
        editComment.delegate = self
        editComment.text = "Add a comment"
        editComment.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    
    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendComments(_ sender: UIButton?) {
        mentionTableView.isHidden = true
        hashtagTableView.isHidden = true
        
        hashtags = []
        mentions = []
        
        print("inside send comments")
        editComment.resignFirstResponder()
        let commentText = editComment.text.components(separatedBy: " ")
        print("comment text: \(commentText)")
        for eachText in commentText {
            if eachText.contains("#") {
                hashtags.append(eachText)
            }
            else if eachText.contains("@") {
                mentions.append(eachText)
            }
        }
        
        if isEdit {
            
            let set1: Set = Set(previousHashtags)
            let set2: Set = Set(hashtags)
            
            let intersection = set1.intersection(set2)
            
            addedHashtags = Array(set2.subtracting(intersection))
            removedHashtags = Array(set1.subtracting(intersection))
            
            request.editComment(type: type, commentId: addComment["_id"].string!, commentText: editComment.text, userId: currentUser["_id"].string!, hashtag: hashtags, addedHashtags: addedHashtags, removedHashtags: removedHashtags, photoId: photoId, completion: {(response) in
                
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
        else {
            setAllComments(editComment.text)
            editComment.text = ""
        }
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
            print(comments.count)
            if comments.count != nil {
                self.commentText.text = "\(comments.count) Comments"
            }
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView.tag {
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTwo") as! PhotoMentionTableViewCell
            cell.titleLabel.text = mentionSuggestions[indexPath.row]["urlSlug"].string!
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PhotoSuggestionsTableViewCell
            cell.titleLabel.text = hashtagSuggestions[indexPath.row]["title"].string!
            cell.titleStats.text = "\(hashtagSuggestions[indexPath.row]["count"])"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PhotoCommentCell
            cell.profileName.text = comments[indexPath.row]["user"]["name"].string!
            cell.profileComment.text = comments[(indexPath as NSIndexPath).row]["text"].string!
            DispatchQueue.main.async(execute: {
                cell.profileImage.hnk_setImageFromURL(getImageURL(self.comments[indexPath.row]["user"]["profilePicture"].stringValue, width: 100))
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
            
            cell.profileComment.customize { label in
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
        
        var usr:String = ""
        let userm = User()
        if currentUser["_id"].stringValue == userm.getExistingUser() {
            usr = currentUser["_id"].stringValue
        }else{
            usr = userm.getExistingUser()
        }
        
        if self.comments[indexPath.row]["user"]["_id"].string! == usr {
            
            let more = UITableViewRowAction(style: .normal, title: "  Edit  ") { action, index in
                print("edit button tapped")
                
                self.editComment.text = self.comments[indexPath.row]["text"].string!
                self.previousHashtags = self.getHashtagsFromText(oldText: self.comments[indexPath.row]["text"].string!)
                self.addComment = self.comments[indexPath.row]
                self.isEdit = true
                
            }
            //more.backgroundColor = UIColor.lightGray
//            let moreImage = UIImageView(image: UIImage(named: "edit.png"))
//            moreImage.contentMode = .scaleAspectFit
            more.backgroundColor = mainOrangeColor
            
            let favorite = UITableViewRowAction(style: .normal, title: "  Delete  ") { action, index in
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
//            let favoriteImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 80))
//            favoriteImage.image = UIImage(named: "delete.png")
//            favoriteImage.contentMode = .scaleAspectFit
            favorite.backgroundColor = mainOrangeColor
            
            return [more, favorite]
        }
            
        else {
            
            let share = UITableViewRowAction(style: .normal, title: "  Reply  ") { action, index in
                print("reply button tapped")
                
                let userTag = "@\(self.comments[indexPath.row]["user"]["urlSlug"].string!)"
                self.editComment.text = userTag
                
            }
            share.backgroundColor = mainOrangeColor
            
            let report = UITableViewRowAction(style: .normal, title: " Report ") { action, index in
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
            report.backgroundColor = mainOrangeColor
            
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
    
     override func popVC(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    var textVar = ""
    
    func textViewDidChange(_ textView: UITextView) {
        
        let commentText = textView.text.components(separatedBy: " ")
        textVar = commentText.last!
        //container.alpha = 0
        //containerTwo.alpha = 0
        
        if textVar.contains("#") {
            hashtagTableView.isHidden = false
            mentionTableView.isHidden = true
            getHashtags()
            print("hashtag in text")
            //            container.alpha = 1
            //            containerTwo.alpha = 0
            //            performSegue(withIdentifier: "myEmbeddedSegue", sender: nil)
        }
        else if textVar.contains("@") {
            
            textVar = String(textVar.characters.dropFirst())
            mentionTableView.isHidden = false
            hashtagTableView.isHidden = true
            getMentions()
            print("mentions in text")
            //            suggestionFor = "mentions"
            //            containerTwo.alpha = 1
            //            container.alpha = 0
            //            performSegue(withIdentifier: "myEmbeddedSegueTwo", sender: nil)
        } else {
            hashtagTableView.isHidden = true
            mentionTableView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView.tag {
        case 2:
            mentionTableView.isHidden = true
            let cell = mentionTableView.cellForRow(at: indexPath) as! PhotoMentionTableViewCell
            mentions.append(mentionSuggestions[indexPath.row]["_id"].string!)
            modifyText(textView: editComment, modifiedString: cell.titleLabel.text!, replacableString: textVar, whichView: "@")
        case 1:
            hashtagTableView.isHidden = true
            let cell = hashtagTableView.cellForRow(at: indexPath) as! PhotoSuggestionsTableViewCell
            modifyText(textView: editComment, modifiedString: cell.titleLabel.text!, replacableString: textVar, whichView: "#")
        default:
            break
        }
        
    }
    
//    func modifyText(textView: UITextView, modifiedString: String, replacableString: String) {
//        
//        if replacableString == "" {
//            textView.text = "\(textView.text!)\(modifiedString)"
//        } else {
//            let myString = textView.text as NSString
//            textView.text = myString.replacingOccurrences(of: replacableString, with: modifiedString)
//        }
//        
//    }
    
    func modifyText(textView: UITextView, modifiedString: String, replacableString: String, whichView: String) {
        
        if replacableString == "" {
            
            textView.text = "\(textView.text!)\(modifiedString)"
            
        } else {
            
            let myString = textView.text as NSString
            
            let myRange = myString.range(of: whichView, options: .backwards)
            
            textView.text = myString.replacingOccurrences(of: replacableString, with: modifiedString, options: .backwards, range: myRange)
            
        }
        
    }
    
    //MARK: - Keyboard Handling
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if comments.count > 0 {
                commentTableView.scrollToRow(at: (NSIndexPath(row: (comments.count-1), section: 0)) as IndexPath, at: .top, animated: true)
            }
            bottomLayoutConstraint.constant = keyboardSize.height
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        bottomLayoutConstraint.constant = 0
    }
    
    
    //MARK: - TextView Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        editComment.resignFirstResponder()
        sendComments(nil)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
//        else {
//            if textView.text == "" && text == "" {
//                textView.text = "Add a comment"
//                textView.textColor = UIColor.lightGray
//            }
//            else{
//                textView.textColor = mainBlueColor
////                addCommentLabel.isHidden = true
//            }
//        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = mainBlueColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a comment"
            textView.textColor = UIColor.lightGray
        }
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "myEmbeddedSegue") {
//            print("hashtag segue")
//            let childViewController = segue.destination as! SuggestionsViewController
//            childViewController.getSuggestions()
//            let commentText = editComment.text.components(separatedBy: " ")
//            childViewController.textVar = commentText.last!
//        }
//        else if (segue.identifier == "myEmbeddedSegueTwo") {
//            print("mention segue")
//            let childViewController = segue.destination as! PhotoMentionTableViewCell
//            //            childViewController.getMentions()
//            let commentText = editComment.text.components(separatedBy: " ")
//            childViewController.textVar = commentText.last!
//        }
//    }
    
    func getMentions() {
        
        request.getMentions(userId: currentUser["_id"].string!, searchText: textVar, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.mentionSuggestions = response["data"].array!
                    self.mentionTableView.reloadData()
                    
                }
                else {
                    
                    
                }
                
            })
            
        })
    }
    
    func setAllComments(_ comment: String) {
        var usr:String = ""
        let userm = User()
        if currentUser["_id"].stringValue == userm.getExistingUser() {
            usr = currentUser["_id"].stringValue
        }else{
            usr = userm.getExistingUser()
        }
        
        request.commentOn(id: "", userId: usr, commentText: comment, hashtags: hashtags, mentions: mentions, photoId: photoId, type: self.type, videoId: photoId, journeyId: "", itineraryId: "", completion: {(response) in
                
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
        if(self.type == "Video" ) {
            request.getVideoComments(photoId, userId: currentUser["_id"].string!, pageno:1, completion: {(response) in
                
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
        } else {
            request.getPhotoComments(photoId, userId: currentUser["_id"].string!, pageno:1, completion: {(response) in
                
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
    }
    
    func getHashtags() {
        
        request.getHashtags(hashtag: textVar, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.hashtagSuggestions = response["data"].array!
                    self.hashtagTableView.reloadData()
                    
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
    @IBOutlet weak var profileComment: ActiveLabel!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var calendarText: UILabel!
    @IBOutlet weak var clockText: UILabel!
    
}

class PhotoMentionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class PhotoSuggestionsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleStats: UILabel!
}
