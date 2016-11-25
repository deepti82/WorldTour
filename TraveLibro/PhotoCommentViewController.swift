//
//  PhotoCommentViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 25/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

//class PhotoCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
//    
//    @IBOutlet weak var commentTableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return comments.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PhotoCommentCell
//        cell.profileName.text = comments[indexPath.row]["user"]["name"].string!
//        cell.profileComment.text = comments[(indexPath as NSIndexPath).row]["text"].string!
//        DispatchQueue.main.async(execute: {
//            cell.profileImage.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(self.comments[indexPath.row]["user"]["profilePicture"])&width=100")!))
//            makeTLProfilePicture(cell.profileImage)
//        })
//        
//        let dateFormatter = DateFormatter()
//        let timeFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
//        let date = dateFormatter.date(from: comments[indexPath.row]["createdAt"].string!)
//        dateFormatter.dateFormat = "dd MMM, yyyy"
//        timeFormatter.dateFormat = "hh:mm a"
//        cell.calendarText.text = "\(dateFormatter.string(from: date!))"
//        cell.clockText.text = "\(timeFormatter.string(from: date!))"
//        cell.clockIcon.text = String(format: "%C", faicon["clock"]!)
//        cell.calendarIcon.text = String(format: "%C", faicon["calendar"]!)
//        
//        cell.profileComment.customize {label in
//            label.handleMentionTap {
//                
//                let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Mention", message: $0, preferredStyle: .alert)
//                let cancelActionButton: UIAlertAction = UIAlertAction(title: "OK", style: .default) {action -> Void in}
//                actionSheetControllerIOS8.addAction(cancelActionButton)
//                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
//            }
//            label.handleHashtagTap {
//                
//                let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Hashtag", message: $0, preferredStyle: .alert)
//                let cancelActionButton: UIAlertAction = UIAlertAction(title: "OK", style: .default) {action -> Void in}
//                actionSheetControllerIOS8.addAction(cancelActionButton)
//                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
//            }
//            label.handleURLTap { let actionSheetControllerIOS8: UIAlertController =
//                
//                UIAlertController(title: "Url", message: "\($0)", preferredStyle: .alert)
//                let cancelActionButton: UIAlertAction = UIAlertAction(title: "OK", style: .default) {action -> Void in}
//                actionSheetControllerIOS8.addAction(cancelActionButton)
//                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
//            }
//        }
//        
//        return cell
//        
//    }
//    
//    func keyboardWillShow(_ notification: Notification) {
//        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            self.view.frame.origin.y -= keyboardSize.height
//        }
//    }
//    
//    func keyboardWillHide(_ notification: Notification) {
//        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            self.view.frame.origin.y += keyboardSize.height
//        }
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        
//        //addComment.resignFirstResponder()
//        //sendComment(nil)
//        return true
//        
//    }
//    
//    func setAllComments(_ comment: String) {
//        
//        request.commentOnPost(id: postId, postId: otherId, userId: currentUser["_id"].string!, commentText: comment, userName: currentUser["name"].string!, hashtags: hashtags, mentions: mentions, completion: {(response) in
//            
//            DispatchQueue.main.async(execute: {
//                
//                if response.error != nil {
//                    
//                    print("error: \(response.error!.localizedDescription)")
//                    
//                }
//                else if response["value"].bool! {
//                    
//                    self.getAllComments()
//                }
//                else {
//                    
//                    
//                }
//                
//            })
//            
//        })
//        
//    }
//    
//    func getAllComments() {
//        
//        request.getComments(otherId, userId: currentUser["_id"].string!, completion: {(response) in
//            
//            DispatchQueue.main.async(execute: {
//                
//                if response.error != nil {
//                    
//                    print("error: \(response.error!.localizedDescription)")
//                    
//                }
//                else if response["value"].bool! {
//                    
//                    self.comments = response["data"]["comment"].array!
//                    self.commentsTable.reloadData()
//                    
//                }
//                else {
//                    
//                    
//                }
//                
//            })
//            
//        })
//        
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

class PhotoCommentCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileComment: UILabel!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var calendarText: UILabel!
    @IBOutlet weak var clockText: UILabel!
    
}
