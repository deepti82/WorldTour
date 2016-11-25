//
//  SinglePhotoViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 23/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SinglePhotoViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var likeIcon: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    
    @IBOutlet weak var likeText: UILabel!
    @IBOutlet weak var commentText: UILabel!
    
    var index: Int!
    var currentIndex: Int!
    var postId: String!
    var photos: [JSON]!
    var singlePost: JSON!
    
    var likeCount: Int!
    var commentCount: Int!
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
        
        likeIcon.textColor = UIColor.white
        likeText.textColor = UIColor.white
        commentText.textColor = UIColor.white
        
        likeIcon.text = String(format: "%C", faicon["likes"]!)
        //commentIcon.text = String(format: "%C", faicon["comments"]!)
        
        likeText.text = "0 Like"
        commentText.text = "0 Comment"
        
        currentIndex = index

        // Do any additional setup after loading the view.
        
        getPost(postId!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendLike(_ sender: UIButton) {
//        if sender.tag == 1 {
//            sender.tag = 0
//        } else {
//            sender.tag = 1
//        }
        
        print("send likes: \(hasLiked!)")
        
        request.postPhotosLike(photos[currentIndex!].string!, postId: postId!, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    if !self.hasLiked! {
                        
                        sender.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                        self.likeCount = Int(self.likeCount!) + 1
                        self.likeText.text = "\(self.likeCount!) Likes"
                        self.hasLiked = !self.hasLiked
                        
                    }
                    else {
                        
                        sender.setImage(UIImage(named: "like_empty_icon"), for: UIControlState())
                        self.likeCount = Int(self.likeCount!) - 1
                        self.likeText.text = "\(self.likeCount!) Likes"
                        self.hasLiked = !self.hasLiked
                        
                    }
                    
                }
                else {
                    
                }
                
            })
            
        })
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
            self.getSinglePhoto(photos[currentIndex!].string!)
        }
    }
    
    func rightSwipe(_ sender: AnyObject) {
        currentIndex = Int(currentIndex) - 1
        print(currentIndex)
        if currentIndex < 0 {
            currentIndex = Int(currentIndex) + 1
        } else {
            self.getSinglePhoto(photos[currentIndex!].string!)
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
                    print("photos: \(self.photos)")
                    
                    self.getSinglePhoto(self.photos[self.index!].string!)
                }
                    
                else {
                    print("response error!")
                }
            })
            
        })
    }
    
    func getSinglePhoto(_ photoId: String) {
        request.getOnePostPhotos(photoId, singlePost["user"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    print("response: \(response.error?.localizedDescription)")
                }
                    
                else if response["value"].bool! {
                    
                    //self.photos = response["data"]
                    //print("photos: \(self.photos)")
                    
                    let data: JSON = response["data"]
                    
                    DispatchQueue.main.async(execute: {
                        let imageString = URL(string: "\(adminUrl)upload/readFile?file=\(data["name"].string!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                        do {
                            let data = try! Data(contentsOf: imageString!)
                            self.mainImage.image = UIImage(data: data)
                        }
                    })
                    
                    if data["like"].array!.contains(JSON(user.getExistingUser())) {
                        self.likeButton.setImage(UIImage(named: "favorite-heart-button")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                        self.likeButton.tintColor = UIColor.white
                        self.hasLiked = true
                    } else {
                        self.likeButton.setImage(UIImage(named: "like_empty_icon"), for: UIControlState())
                        self.hasLiked = false
                    }
                    
                    self.likeCount = data["likeCount"].int!
                    self.commentCount = data["commentCount"].int!
                    
                    self.likeText.text = "\(self.likeCount!) Like"
                    self.commentText.text = "\(self.commentCount!) Comment"
                    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
