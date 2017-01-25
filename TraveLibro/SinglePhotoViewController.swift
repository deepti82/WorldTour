//
//  SinglePhotoViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 23/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring
import Player

class SinglePhotoViewController: UIViewController,PlayerDelegate {

    var player:Player!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imageCaption: UILabel!
    
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var likeIcon: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    
    @IBOutlet weak var likeText: UILabel!
    @IBOutlet weak var commentText: UILabel!
    var type = "Image"
    var index: Int!
    var currentIndex: Int!
    var postId: String!
    var photos: [JSON]!
    var videos:[JSON]!
    var singlePost: JSON!
    
    var likeCount:Int = 0
    var commentCount:Int = 0
    var hasLiked: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("current post \(postId!) \(index!)")
        
        let leftButton = UIButton(frame: CGRect(x: 20, y: 30, width: 30, height: 30))
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.layer.zPosition = 100
        self.view.addSubview(leftButton)
        //self.customNavigationBar(left: leftButton, right: nil)
        
        bottomView.isHidden = true
        mainImage.isHidden = true
        
        self.view.backgroundColor = UIColor.black
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        bottomView.layer.zPosition = 100
        mainImage.contentMode = .scaleAspectFit
        mainImage.isUserInteractionEnabled = true
        
        likeButton.imageView?.contentMode = .scaleAspectFit
        commentButton.imageView?.contentMode = .scaleAspectFit
        shareButton.imageView?.contentMode = .scaleAspectFit
        
        likeButton.tintColor = UIColor.white
        commentButton.tintColor = UIColor.white
        shareButton.tintColor = UIColor.white
        commentIcon.tintColor = UIColor.white
        likeText.textColor = UIColor.white
        commentText.textColor = UIColor.white
        
        likeIcon.text = String(format: "%C", faicon["likes"]!)
        
        likeText.text = "0 Likes"
        commentText.text = "0 Comments"
        
        currentIndex = index
        
        getPost(postId!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //imageCache = nil
    }
    
    @IBAction func sendLike(_ sender: UIButton) {
       likeButton.animation = "pop"
        likeButton.animateTo()
        print("send likes: \(hasLiked!)")
        print(currentIndex)
        print(photos[currentIndex!])
        print(postId)
        print(currentUser["_id"].string!)
        print(currentUser["name"].string!)
        print(hasLiked)
        if(self.type == "Video") {
            request.postVideoLike(videos[currentIndex!]["_id"].string!, postId: postId!, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked!, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        
                        if !self.hasLiked! {
                            
                            sender.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                            self.likeCount = Int(self.likeCount) + 1
                            self.likeText.text = "\(self.likeCount) Likes"
                            self.hasLiked = !self.hasLiked
                            
                        }
                        else {
                            
                            sender.setImage(UIImage(named: "likeButton"), for: UIControlState())
                            self.likeCount = Int(self.likeCount) - 1
                            self.likeText.text = "\(self.likeCount) Likes"
                            self.hasLiked = !self.hasLiked
                            
                        }
                        
                    }
                    else {
                        
                    }
                    
                })
                
            })
        }
        else {
            request.postPhotosLike(photos[currentIndex!]["_id"].string!, postId: postId!, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked!, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        
                        if !self.hasLiked! {
                            
                            sender.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                            self.likeCount = Int(self.likeCount) + 1
                            self.likeText.text = "\(self.likeCount) Likes"
                            self.hasLiked = !self.hasLiked
                            
                        }
                        else {
                            
                            sender.setImage(UIImage(named: "likeButton"), for: UIControlState())
                            self.likeCount = Int(self.likeCount) - 1
                            self.likeText.text = "\(self.likeCount) Likes"
                            self.hasLiked = !self.hasLiked
                            
                        }
                        
                    }
                    else {
                        
                    }
                    
                })
                
            })
        }
        
    }
    
    @IBAction func sendComment(_ sender: UIButton) {
        let comment = storyboard?.instantiateViewController(withIdentifier: "photoComment") as! PhotoCommentViewController
        comment.postId = postId!
        comment.commentText = self.commentText
        if singlePhotoJSON != nil {
            comment.otherId = singlePhotoJSON["name"].string!
            comment.photoId = singlePhotoJSON["_id"].string!
        }
        if(self.type == "Video") {
            comment.type = "Video"
        }
        //self.navigationController?.pushViewController(comment, animated: true)
        self.present(comment, animated: true, completion: nil)
    }
    
    override func popVC(_ sender: UIButton) {
        //self.navigationController!.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func leftSwipe(_ sender: AnyObject) {
        currentIndex = Int(currentIndex) + 1
        print(currentIndex)
        if currentIndex >= photos.count {
            currentIndex = Int(currentIndex) - 1
        } else {		
            self.getSinglePhoto(photos[currentIndex!]["_id"].string!)
        }
    }
    
    func rightSwipe(_ sender: AnyObject) {
        currentIndex = Int(currentIndex) - 1
        print(currentIndex)
        if currentIndex < 0 {
            currentIndex = Int(currentIndex) + 1
        } else {
            print(photos)
            print(photos[currentIndex])
            self.getSinglePhoto(photos[currentIndex!]["_id"].string!)
        }
    }
    
    func getPost(_ postId: String) {
        request.getOneJourneyPost(id: postId, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    print("response: \(response.error?.localizedDescription)")
                }
                    
                else if response["value"].bool! {
                    
                    self.singlePost = response["data"]
                    self.photos = response["data"]["photos"].array!
                    self.videos = response["data"]["videos"].array!
                    if(self.type == "Video") {
                        self.getSingleVideo(self.videos[0]["_id"].string!)
                    } else {
                        self.getSinglePhoto(self.photos[self.index!]["_id"].string!)
                    }
                }
                    
                else {
                    print("response error!")
                }
            })
            
        })
    }
    
    var singlePhotoJSON: JSON!
    
    func getSinglePhoto(_ photoId: String) {
        request.getOnePostPhotos(photoId, singlePost["user"]["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    print("response: \(response.error?.localizedDescription)")
                }
                    
                else if response["value"].bool! {
                    
                    let data: JSON = response["data"]
                    self.singlePhotoJSON = response["data"]

                    let mainImageString = "\(adminUrl)upload/readFile?file=\(data["name"].string!)"
                    self.mainImage.hnk_setImageFromURL(NSURL(string:mainImageString) as! URL)

                    if data["caption"].string != nil && data["caption"].string != "" {
                        
                        self.imageCaption.text = data["caption"].string!
                    }
                    
                    if data["like"].array!.contains(JSON(user.getExistingUser())) {
                        
                        self.likeButton.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: .normal)
                        self.likeButton.tintColor = UIColor.white
                        self.hasLiked = true
                    }
                    else {
                        
                        self.likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
                        self.hasLiked = false
                    }
                    if(data["likeCount"].int != nil) {
                        self.likeCount = data["likeCount"].int!
                        self.likeText.text = "\(self.likeCount) Like"
                    }
                    if(data["commentCount"].int != nil) {
                        self.commentCount = data["commentCount"].int!
                        self.commentText.text = "\(self.commentCount) Comment"
                    }
                    
                    
                    self.bottomView.isHidden = false
                    self.mainImage.isHidden = false
                    
                    let imageLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwipe(_:)))
                    let imageRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwipe(_:)))
                    
                    imageLeftSwipe.direction = .left
                    imageRightSwipe.direction = .right
                    
                    self.mainImage.addGestureRecognizer(imageLeftSwipe)
                    self.mainImage.addGestureRecognizer(imageRightSwipe)
                    
                }
                    
                    
                else {
                    print("response error!")
                }
            })
            
        })
    }
    
    func playerReady(_ player: Player) {
        self.player.playFromBeginning()
    }
    
    func getSingleVideo(_ photoId: String) {
        request.getOnePostVideos(photoId, singlePost["user"]["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    print("response: \(response.error?.localizedDescription)")
                }
                    
                else if response["value"].bool! {
                    let data: JSON = response["data"]
                    self.singlePhotoJSON = response["data"]
                    print(data);
                    let mainImageString = "\(adminUrl)upload/readFile?file=\(data["name"].string!)"
                    self.mainImage.hnk_setImageFromURL(NSURL(string:mainImageString) as! URL)
                    
                    if data["caption"].string != nil && data["caption"].string != "" {
                        self.imageCaption.text = data["caption"].string!
                    }
                    
                    
                    if (data["likeDone"].bool != nil && data["likeDone"].bool! ) {
                        self.likeButton.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: .normal)
                        self.likeButton.tintColor = UIColor.white
                        self.hasLiked = true
                    }
                    else {
                        self.likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
                        self.hasLiked = false
                    }
                    
                    if(data["likeCount"].int != nil) {
                        self.likeCount = data["likeCount"].int!
                        self.likeText.text = "\(self.likeCount) Like"
                    }
                    if(data["commentCount"].int != nil) {
                        self.commentCount = data["commentCount"].int!
                        self.commentText.text = "\(self.commentCount) Comment"
                    }
                    
                    self.bottomView.isHidden = false
                    self.mainImage.isHidden = false
                    
                    
                    self.player = Player()
                    self.player.delegate = self
                    self.player.view.frame = self.mainImage.bounds
                    self.player.view.clipsToBounds = true
                    self.player.playbackLoops = true
                    self.player.muted = true
                    var videoUrl:URL!
                    videoUrl = URL(string:data["name"].stringValue)
                    self.player.setUrl(videoUrl!)
                    self.mainImage.addSubview(self.player.view)
                }
                    
                    
                else {
                    print("response error!")
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
