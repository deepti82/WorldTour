//
//  LocalLifePostsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 30/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class LocalLifePostsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        
        
        let videoPost = TraveLifeVideoPost(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 550))
        videoPost.layer.cornerRadius = 5.0
        videoPost.clipsToBounds = true
        self.view.addSubview(videoPost)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
