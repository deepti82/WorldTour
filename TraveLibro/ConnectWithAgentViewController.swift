//
//  ConnectWithAgentViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 17/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ConnectWithAgentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = ConnectWithAgent(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 20))
        self.view.addSubview(frame)
        
        
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
