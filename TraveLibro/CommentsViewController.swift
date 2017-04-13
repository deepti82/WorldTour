//
//  CommentsViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/27/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
//import ActiveLabel

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    var postId = ""
    var comments: [JSON] = []
    var ids = ""
    var hashtags: [String] = []
    var mentions: [String] = []
    var mentionSuggestions: [JSON] = []
    var hashtagSuggestions: [JSON] = []
    var previousHashtags: [String] = []
    var editComment: JSON!
    var footerViewOtg: PhotoOTGFooter!
    var footerViewFooter: ActivityFeedFooter!
    var footerViewBasic: ActivityFeedFooterBasic!
    var type: String = ""
    
    @IBOutlet weak var bottomSpaceToSuperview: NSLayoutConstraint!
    @IBOutlet weak var addCommentLabel: UILabel!
    @IBOutlet weak var mentionSuggestionsTable: UITableView!
    @IBOutlet weak var hashTagSuggestionsTable: UITableView!
    @IBOutlet weak var containerTwo: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var addComment: UITextView!
    @IBAction func sendComment(_ sender: UIButton?) {
        print("type ::: \(self.type)")
        mentionSuggestionsTable.isHidden = true
        hashTagSuggestionsTable.isHidden = true
        hashtags = []
        mentions = []
        addComment.delegate = self
        addComment.resignFirstResponder()
        
        let commentText = addComment.text.components(separatedBy: " ")
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
            if addComment.text != "" {
                request.editComment(type: self.type, commentId: editComment["_id"].string!, commentText: addComment.text, userId: currentUser["_id"].string!, hashtag: hashtags, addedHashtags: addedHashtags, removedHashtags: removedHashtags, photoId: "", completion: {(response) in
                    DispatchQueue.main.async(execute: {
//                        loader.hideOverlayView()
                        if response.error != nil {
                            print("error: \(response.error!.localizedDescription)")
                        }
                        else if response["value"].bool! {
                            self.getAllComments()
                        }
                        else {}
                    })
                })
            }
        }
        else {
            setAllComments(addComment.text)
            addComment.text = ""
        }
    }
    
    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
//        loader.showOverlay(self.view)
        super.viewDidLoad()
        getAllComments()
        print("user....type\(type)")
        setTopNavigation("Comment")
        commentsTable.tableFooterView = UIView()
        commentsTable.estimatedRowHeight = 80.0
        commentsTable.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addComment.returnKeyType = .done
        addComment.delegate = self
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(CommentsViewController.closeAdd(_:)), for: .touchUpInside)
        let rightButton = UIButton()
        globalNavigationController.topViewController?.customNavigationBar(left: leftButton,right:rightButton)
    }
    
    
    
    func closeAdd(_ sender:UIButton) {
        _ = globalNavigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Keyboard Handling
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if comments.count > 0 {
                commentsTable.scrollToRow(at: (NSIndexPath(row: (comments.count-1), section: 0)) as IndexPath, at: .top, animated: true)
            }
            bottomSpaceToSuperview.constant = keyboardSize.height
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        bottomSpaceToSuperview.constant = 0
    }
    
    
    //MARK: - TextView Delegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        addCommentLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if addComment.text == "" {
            addCommentLabel.isHidden = false            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        addComment.resignFirstResponder()
        sendComment(nil)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        else {
            if textView.text == "" && text == "" {
                addCommentLabel.isHidden = false
            }
            else{
                addCommentLabel.isHidden = true
            }
        }
        return true
    }
    
    
    var removedHashtags: [String] = []
    var addedHashtags: [String] = []
    var isEdit = false
    
    
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
                self.addComment.text = self.comments[indexPath.row]["text"].string!
                self.previousHashtags = self.getHashtagsFromText(oldText: self.comments[indexPath.row]["text"].string!)
                self.editComment = self.comments[indexPath.row]
                self.isEdit = true
                self.addCommentLabel.isHidden = true
            }
//            let moreImage = UIImageView(image: UIImage(named: "penciltranswhite (2)"))
//            moreImage.contentMode = .scaleAspectFit
//            moreImage.clipsToBounds = true
//            more.backgroundColor = UIColor(patternImage: moreImage.image!)
              more.backgroundColor = mainOrangeColor
            
            let favorite = UITableViewRowAction(style: .default, title: " Delete " ) { action, index in
                print("delete button tapped")
                request.deleteComment(commentId: self.comments[indexPath.row]["_id"].string!, completion: {(response) in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if response.error != nil {
                            
                            print("error: \(response.error!.localizedDescription)")
                            
                        }
                        else if response["value"].bool! {
                            self.isEdit = false
                            self.getAllComments()
                        }
                        else {
                            
                            
                        }
                        
                    })
                    
                })
                
                
            }
//            let favoriteImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 200))
//            
//            favoriteImage.image = UIImage(named: "trashtranswhite (2)")
//            favoriteImage.contentMode = .top
            
              favorite.backgroundColor = mainOrangeColor
    
//            favoriteImage.backgroundColor = mainOrangeColor
//            favorite.backgroundColor = mainOrangeColor
            
            return [favorite, more]
        }
        
        else {
            
            let share = UITableViewRowAction(style: .normal, title: " Reply  ") { action, index in
                print("reply button tapped")
                
                let userTag = "@\(self.comments[indexPath.row]["user"]["urlSlug"].string!)"
                self.addComment.text = userTag
                
            }
//            share.backgroundColor = UIColor(patternImage: UIImage(named: "backtranswhite (1)")!)
              share.backgroundColor = UIColor.gray
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
                showPopover(optionsController: actionSheet, sender: tableView, vc: self)
//                self.present(actionSheet, animated: true, completion: nil)
            }
//            report.backgroundColor = UIColor(patternImage: UIImage(named: "info (3)")!)
              report.backgroundColor = UIColor.red
        
            return [report, share]
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
        if textView.text == "" {
            addCommentLabel.isHidden = false
        }
        let commentText = textView.text.components(separatedBy: " ")
        textVar = commentText.last!
        if textVar.contains("#") {
            hashTagSuggestionsTable.isHidden = false
            mentionSuggestionsTable.isHidden = true
            getHashtags()
        }
        else if textVar.contains("@") {
            
            textVar = String(textVar.characters.dropFirst())
            mentionSuggestionsTable.isHidden = false
            hashTagSuggestionsTable.isHidden = true
            getMentions()
        } else {
            hashTagSuggestionsTable.isHidden = true
            mentionSuggestionsTable.isHidden = true
        }
    }
    

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return  min((44.0 * CGFloat(indexPath.row) + 1), 85)
//    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView.tag {
        case 2:
            mentionSuggestionsTable.isHidden = true
            let cell = mentionSuggestionsTable.cellForRow(at: indexPath) as! MentionSuggestionsTableViewCell
            mentions.append(mentionSuggestions[indexPath.row]["_id"].string!)
            modifyText(textView: addComment, modifiedString: cell.titleLabel.text!, replacableString: textVar, whichView: "@")
        case 1:
            hashTagSuggestionsTable.isHidden = true
            let cell = hashTagSuggestionsTable.cellForRow(at: indexPath) as! SuggestionsTableViewCell
            modifyText(textView: addComment, modifiedString: cell.titleLabel.text!, replacableString: textVar, whichView: "#")
        default:
            break
        }
        
    }
    
    func modifyText(textView: UITextView, modifiedString: String, replacableString: String, whichView: String) {
        
        if replacableString == "" {
            
            textView.text = "\(textView.text!)\(modifiedString)"
            
        } else {
            
            let myString = textView.text as NSString
            let repOf = replacableString
            let myRange = myString.range(of: repOf, options: .backwards)
            textView.text = myString.replacingOccurrences(of: replacableString, with: modifiedString, options: .backwards, range: myRange)
            
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
                    print("datamention\(self.mentionSuggestions)")
                    self.mentionSuggestionsTable.reloadData()
                    
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
        request.commentOn(id: ids, userId: usr, commentText: comment, hashtags: hashtags, mentions: mentions, photoId: ids, type: self.type, videoId: ids, journeyId: ids, itineraryId: ids, completion: {(response) in
            
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
        print("?????????? \(self.type)")
        request.getComments(ids, type: self.type, userId: currentUser["_id"].string!, pageno: 1, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                loader.hideOverlayView()
                
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
        switch tableView.tag {
        case 2:
            return mentionSuggestions.count
        case 1:
            return hashtagSuggestions.count
        default:
            if(footerViewOtg != nil) {
                footerViewOtg.setCommentCount(comments.count)
            }
            if(footerViewFooter != nil) {
                footerViewFooter.setCommentCount(comments.count)
            }
            if(footerViewBasic != nil) {
                footerViewBasic.setCommentCount(comments.count)
            }
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView.tag {
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTwo") as! MentionSuggestionsTableViewCell
            cell.urlSlug.text = mentionSuggestions[indexPath.row]["urlSlug"].string!
            cell.titleLabel.text = mentionSuggestions[indexPath.row]["name"].string!
            cell.profilePhoto.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(mentionSuggestions[indexPath.row]["profilePicture"])", width: 100))
            HiBye(cell.profilePhoto)
            
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
//            cell.commentScroll.contentSize = CGSize(width: 50, height: 0)
            if textVar.contains("@"){
                cell.profileComment.font = UIFont(name: "Avenir-Heavy", size: 14)
//                cell.commentScroll.contentSize = CGSize(width: cell.profileComment.frame.width, height: 0)
            }else {
                print("hello")
            }
            DispatchQueue.main.async(execute: {
                cell.profileImage.image = UIImage(named: "logo-default")
                cell.profileImage.hnk_setImageFromURL(URL(string: "\(adminUrl)upload/readFile?file=\(self.comments[indexPath.row]["user"]["profilePicture"])&width=100")!)
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
    
    func getHashtags() {
        request.getHashtags(hashtag: textVar, completion: {(response) in
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                }
                else if response["value"].bool! {
                    self.hashtagSuggestions = response["data"].array!
                    self.hashTagSuggestionsTable.reloadData()
                }
                else {}
            })
        })
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
    @IBOutlet weak var commentScroll: UIScrollView!
}

class MentionSuggestionsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var urlSlug: UILabel!
}

class SuggestionsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statistics: UILabel!
}


