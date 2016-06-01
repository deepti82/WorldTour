//
//  SetProfilePictureViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SetProfilePictureViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var pictureScroll: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureScroll.contentSize.height = profileImageView.frame.size.height * 2
        pictureScroll.contentSize.width = profileImageView.frame.size.width * 2
        pictureScroll.maximumZoomScale = 5.0
        
        
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
