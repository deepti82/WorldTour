//
//  VideoPost.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 29/04/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class VideoPost: UIView {
    
    @IBOutlet weak var mainPostView: UIView!
    @IBOutlet weak var dayImage: UIImageView!
    @IBOutlet weak var videoTime: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var likeText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "VideoPost", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
        likeImage.image = UIImage(named: "add_circle")
        commentImage.image = UIImage(named: "info_circle")
        shareImage.image = UIImage(named: "add_circle")
        optionImage.image = UIImage(named: "info_circle")
        dayImage.image = UIImage(named: "add_circle")
        //likeText.text = "like"
        likeText.font = UIFont(name: "Avenir-Roman", size: 10)
        videoTime.font = UIFont(name: "Avenir-Roman", size: 10)
        
        mainPostView.layer.shadowColor = UIColor.blackColor().CGColor
        mainPostView.layer.shadowOpacity = 0.3
        mainPostView.layer.shadowOffset = CGSizeZero
        mainPostView.layer.shadowRadius = 1
        dayImage.layer.zPosition = 10
        
        // line 1
        let line = UIView(frame: CGRectMake(0, 0, self.frame.size.width - 40, 1))
        line.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 85) //285)
        line.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 255/255)
        self.addSubview(line)
        
        // line 2
        let line2 = UIView(frame: CGRectMake(0, 0, self.frame.size.width - 40, 1))
        line2.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 40) //330)
        line2.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 255/255)
        self.addSubview(line2)
        
        // video icon image
        let videoIconImage = UIImageView(frame: CGRectMake(0, 0, 60, 40))
        videoIconImage.center = CGPointMake(self.frame.size.width / 2, videoImage.frame.size.height / 2)
        videoIconImage.image = UIImage(named: "add_circle")
        videoIconImage.backgroundColor = UIColor.redColor()
        self.addSubview(videoIconImage)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
