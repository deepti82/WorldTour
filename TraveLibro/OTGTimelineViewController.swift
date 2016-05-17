//
//  OTGTimelineViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 16/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class OTGTimelineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBackGround(self)
        
        let line = drawLine(frame: CGRect(x: self.view.frame.size.width/2, y: 60, width: 10, height: self.view.frame.size.height - 60))
        line.backgroundColor = UIColor.clearColor()
        self.view.addSubview(line)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: self.view.frame.size.height - 60))
        scrollView.contentSize.height = 5500
        scrollView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(scrollView)
        
        let timelineView = TimelineScroll(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: scrollView.frame.size.height))
        timelineView.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(timelineView)
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
