//
//  NewProfilePosts.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 24/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class NewProfilePosts: UIView {

    @IBOutlet weak var seperatorViewUp: UIView!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var timestamp: UIStackView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptiveText: UILabel!
    @IBOutlet weak var videoPlayView: UIView!
    @IBOutlet weak var OTGLabelView: UIView!
    @IBOutlet weak var profileImageView: UIView!
    @IBOutlet weak var titleConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconButtonUpConstraint: NSLayoutConstraint!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let photobarOne = UIImageView(frame: CGRect(x: 8, y: 0, width: scrollView.frame.height, height: scrollView.frame.height))
        photobarOne.image = UIImage(named: "photobar1")
        scrollView.addSubview(photobarOne)
        
        let photobarTwo = UIImageView(frame: CGRect(x: scrollView.frame.height + 18, y: 0, width: scrollView.frame.height, height: scrollView.frame.height))
        photobarTwo.image = UIImage(named: "photobar2")
        scrollView.addSubview(photobarTwo)
        
        let photobarThree = UIImageView(frame: CGRect(x: (scrollView.frame.height*2) + 28, y: 0, width: scrollView.frame.height, height: scrollView.frame.height))
        photobarThree.image = UIImage(named: "photobar3")
        scrollView.addSubview(photobarThree)
        
        let photobarFour = UIImageView(frame: CGRect(x: (scrollView.frame.height*3) + 38, y: 0, width: scrollView.frame.height, height: scrollView.frame.height))
        photobarFour.image = UIImage(named: "photobar4")
        scrollView.addSubview(photobarFour)
        
        let photobarFive = UIImageView(frame: CGRect(x: (scrollView.frame.height*4) + 48, y: 0, width: scrollView.frame.height, height: scrollView.frame.height))
        photobarFive.image = UIImage(named: "photobar1")
        scrollView.addSubview(photobarFive)
        
        scrollView.contentSize.width = (scrollView.frame.height*5) + 45
        
        OTGLabelView.layer.cornerRadius = 5
        OTGLabelView.clipsToBounds = true
        
        let profileImage = ProfileImage(frame: CGRect(x: 0, y: 0, width: profileImageView.frame.width, height: profileImageView.frame.height))
        profileImageView.addSubview(profileImage)
        
        likesLabel.text = String(format: "%C", faicon["likes"]!)
        
        mainView.layer.cornerRadius = 5
        mainView.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NewProfilePosts", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
    }

}
