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
        getDarkBackGroundBlue(self)
        setNavigationBarItem()
        
//        let backgroundColour = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        backgroundColour.backgroundColor = UIColor(red: 35/255, green: 44/255, blue: 73/255, alpha: 0.7)
//        backgroundColour.layer.zPosition = 0
//        self.view.addSubview(backgroundColour)
        
        mailButton.setTitle(emailIcon, for: UIControlState())
        whatsappButton.setTitle(whatsAppIcon, for: UIControlState())
        facebookButton.setTitle(facebookIcon, for: UIControlState())
        
        mailButton.layer.cornerRadius = 5
        whatsappButton.layer.cornerRadius = 5
        facebookButton.layer.cornerRadius = 5
        
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
