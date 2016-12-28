//
//  PhotosOTG.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 16/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring

class PhotosOTG: UIView {

    @IBOutlet weak var morePhotosScroll: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var postDp: UIImageView!
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var likeHeart: UILabel!
    @IBOutlet weak var photosTitle: ActiveLabel!
    @IBOutlet weak var likeViewLabel: UILabel!
    @IBOutlet weak var photosStack: UIStackView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet var otherPhotosStack: [UIImageView]!
    @IBOutlet weak var whatPostIcon: UIButton!
    @IBOutlet weak var lineUp: drawLine!
    
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var photosHC: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var likeCommentView: UIView!
    var updateTimer:Timer!
    var imageRatio:CGFloat = 1.0;
    var likeCount = 0
    var mapImage: String!
    var newHeight:CGFloat = 400.0;
    var isImage = false;
    var isMoreImage = false;
    var horizontalScrollForPhotos:HorizontalLayout!
    @IBAction func sendLikes(_ sender: UIButton) {
            
        print("like button tapped \(sender.titleLabel!.text)")
        
        var hasLiked = false
        
        if sender.tag == 1 {
            
            hasLiked = true
            sender.tag = 0
            
        }
        else {
            
            sender.tag = 1
        }
        
        print("send likes: \(sender.tag) \(hasLiked)")
        
        request.likePost(sender.titleLabel!.text!, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    if sender.tag == 1 {
                        sender.setImage(UIImage(named: "favorite-heart-button"), for: .normal)
                        sender.tintColor = mainOrangeColor
                        self.likeCount += 1
                        self.likeViewLabel.text = "\(self.likeCount) Likes"
                        
                    }
                    else {
                        
                        sender.setImage(UIImage(named: "like_empty_icon"), for: .normal)
                        sender.tintColor = mainBlueColor
                        if self.likeCount <= 0 {
                            self.likeCount = 0
                        } else {
                            self.likeCount -= 1
                        }
                        
                        self.likeViewLabel.text = "\(self.likeCount) Likes"
                        
                    }
                    
                }
                else {
                    
                }
                
            })
            
        })
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        postDp.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=100")!)
        makeTLProfilePicture(postDp)
        
        bgView.layer.cornerRadius = 5
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 2, height: 1)
        
        
        
        postDp.layer.cornerRadius = 10
        postDp.layer.borderWidth = 2
        postDp.layer.borderColor = UIColor.orange.cgColor
        
        
        photosTitle.numberOfLines = 0
        let customType = ActiveType.custom(pattern: "\\swith\\b") //Regex that looks for "with"
        likeButton.tintColor = mainBlueColor
        commentButton.tintColor = mainBlueColor
        shareButton.tintColor = mainBlueColor
        optionsButton.tintColor = mainBlueColor
        commentIcon.tintColor = mainBlueColor
        likeButton.imageView?.contentMode = .scaleAspectFit
        commentButton.imageView?.contentMode = .scaleAspectFit
        shareButton.imageView?.contentMode = .scaleAspectFit
        
        mainPhoto.autoresizingMask = [.flexibleHeight]
        
        likeHeart.text = String(format: "%C", faicon["likes"]!)
        clockLabel.text = String(format: "%C", faicon["clock"]!)
        calendarLabel.text = String(format: "%C", faicon["calendar"]!)
        
        lineUp.backgroundColor = UIColor.clear
        
        horizontalScrollForPhotos = HorizontalLayout(height: morePhotosScroll.frame.height)
        morePhotosScroll.addSubview(horizontalScrollForPhotos)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PhotosOTG", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    @IBAction func popEffect(_ sender: SpringButton) {
        likeButton.animation = "pop"
        likeButton.animateTo()
    }
    func setMapImage(mapUrl: String) {
        mainPhoto.hnk_setImageFromURL(URL(string: mapUrl)!)
    }
    
    
    func addPhotoToLayout(_ post: Post) {
        self.horizontalScrollForPhotos.removeAll()
        for i in 1 ..< post.imageArr.count {
            let photosButton = UIButton(frame: CGRect(x: 10, y: 0, width: 65, height: 65))
            photosButton.backgroundColor = mainGreenColor
            photosButton.imageView?.sizeToFit()
            photosButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
            if(post.imageArr[i].image != nil) {
                photosButton.setImage(post.imageArr[i].image, for: .normal)
            } else {
                photosButton.imageView?.frame.size.height = 65
                photosButton.imageView?.frame.size.width = 65
                photosButton.imageView?.hnk_setImageFromURL(post.imageArr[i].imageUrl)
            }
            photosButton.layer.cornerRadius = 5.0
            photosButton.tag = i
            photosButton.clipsToBounds = true
//            photosButton.addTarget(self, action: #selector(self.addCaption(_:)), for: .touchUpInside)
            self.horizontalScrollForPhotos.addSubview(photosButton)
        }
    
        self.horizontalScrollForPhotos.layoutSubviews()
        self.morePhotosScroll.contentSize = CGSize(width: self.horizontalScrollForPhotos.frame.width, height: self.horizontalScrollForPhotos.frame.height)
    }
    
    func callFunction() {
        let image = self.mainPhoto.image
        
        let widthInPixels = image?.cgImage?.width
        let heightInPixels =  image?.cgImage?.height
        print("function called")
        if(widthInPixels != 180) {
            updateTimer.invalidate()
            imageRatio = CGFloat(widthInPixels!)/CGFloat(heightInPixels!);
            newHeight = screenWidth / imageRatio
            setHeight(newHeight)
        }
        
       
    }
    
    
    func setHeight (_ imageHeight:CGFloat) {
        var accheight:CGFloat = 60 + 75 + 90
        
        if(isImage) {
            accheight = accheight + imageHeight
            bgView.frame.size = CGSize(width: screenWidth, height: imageHeight)
            mainPhoto.frame.size = CGSize(width: screenWidth, height: imageHeight)
            if(isMoreImage) {
                accheight = accheight + 60
                morePhotosScroll.frame.origin.y = 60+75+imageHeight
                likeCommentView.frame.origin.y = 60+75+imageHeight+60
            } else {
                morePhotosScroll.alpha = 0
                likeCommentView.frame.origin.y = 60+75+imageHeight
            }
        } else {
            bgView.alpha = 0
            likeCommentView.frame.origin.y = 60+75
        }
        
        self.frame.size = CGSize(width: screenWidth, height: accheight)
        globalNewTLViewController.addHeightToLayout(height: 50.0)
    };
    
    
    func generatePost(_ post: Post) {
        post.getThought()
        self.photosTitle.text = post.finalThought
        
        headerView.frame.size = CGSize(width: screenWidth, height: 75)
        
        
        if(post.imageArr.count > 0) {
            self.isImage = true;
            self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFit
            self.mainPhoto.hnk_setImageFromURL(post.imageArr[0].imageUrl)
            updateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: "callFunction", userInfo: nil, repeats: true)
            if(post.imageArr.count > 1) {
                self.addPhotoToLayout(post)
                isMoreImage = true;
            }
        } else {
            self.setHeight(0)
        }
        
        
//        self.likeCommentView.backgroundColor = mainOrangeColor
        post.getTypeOfPost()
        if((post.typeOfPost) != nil) {
            switch(post.typeOfPost) {
            case "Location":
                self.whatPostIcon.setImage(UIImage(named: "location_icon"), for: .normal)
            case "Image":
                self.whatPostIcon.setImage(UIImage(named: "camera_icon"), for: .normal)
            case "Videos":
                self.whatPostIcon.setImage(UIImage(named: "video"), for: .normal)
            case "Thoughts":
                self.whatPostIcon.setImage(UIImage(named: "pen_icon"), for: .normal)
            default:
                break
            }
        }
    }
}
