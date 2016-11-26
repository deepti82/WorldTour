//
//  CreatePostViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 25/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var newScroll: UIScrollView!
    let backView = UIView()
    var darkBlur: UIBlurEffect!
    var blurView: UIVisualEffectView!
    var addView: AddActivityNew!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getDarkBackGround(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: .normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        
        let postButton = UIButton()
        postButton.setTitle("Post", for: .normal)
        //postButton.addTarget(self, action: #selector(self.newPost(_:)), for: .touchUpInside)
        postButton.titleLabel!.font = UIFont(name: "Avenir-Roman", size: 16)

        self.customNavigationBar(left: nil, right: postButton)
        
        backView.frame = self.view.frame
        
        for subview in self.view.subviews {
            if subview.tag == 8 {
                flag = 1
                backView.isHidden = false
                addView.isHidden = false
                scrollView.isHidden = false
            }
        }
        
        if flag == 0 {
            self.view.addSubview(backView)
            darkBlur = UIBlurEffect(style: .dark)
            blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame.size.height = backView.frame.height
            blurView.frame.size.width = backView.frame.width
            blurView.layer.zPosition = -1
            blurView.isUserInteractionEnabled = false
            backView.addSubview(blurView)
        }
        
        addView = AddActivityNew(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        //displayFriendsCount()
        addView.layer.zPosition = 10
        scrollView.addSubview(addView)
        scrollView.contentSize.height = self.view.frame.height
        //addLocationTapped(nil)
        
        addView.addLocationButton.addTarget(self, action: #selector(NewTLViewController.addLocationTapped(_:)), for: .touchUpInside)
        addView.photosButton.addTarget(self, action: #selector(NewTLViewController.addPhotos(_:)), for: .touchUpInside)
        addView.videosButton.addTarget(self, action: #selector(NewTLViewController.addVideos(_:)), for: .touchUpInside)
        addView.thoughtsButton.addTarget(self, action: #selector(NewTLViewController.addThoughts(_:)), for: .touchUpInside)
        addView.tagFriendButton.addTarget(self, action: #selector(NewTLViewController.tagMoreBuddies(_:)), for: .touchUpInside)
        addView.postButton.addTarget(self, action: #selector(NewTLViewController.newPost(_:)), for: .touchUpInside)
        addView.postButtonUp.addTarget(self, action: #selector(NewTLViewController.newPost(_:)), for: .touchUpInside)
        addView.postCancelButton.addTarget(self, action: #selector(NewTLViewController.closeAdd(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popVC() {
        //self.navigationController.po
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
