//
//  UploadDisplayPicViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class UploadDisplayPicViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let uploadView = AddDisplayPic(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300))
        uploadView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3)
        self.view.addSubview(uploadView)
        
        
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
