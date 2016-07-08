//
//  InviteFriendsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class InviteFriendsViewController: UIViewController {

    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        setNavigationBarItem()
        
        mailButton.setTitle(emailIcon, forState: .Normal)
        whatsappButton.setTitle(whatsAppIcon, forState: .Normal)
        facebookButton.setTitle(facebookIcon, forState: .Normal)
        
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
