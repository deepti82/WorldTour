//
//  SetProfilePictureViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SetProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        let pagerVC = storyboard?.instantiateViewControllerWithIdentifier("DisplayCards") as! DisplayCardsViewController
        setCheckInNavigationBarItem(pagerVC)
        
        let uploadView = AddDisplayPic(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300))
        uploadView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3)
        self.view.addSubview(uploadView)
        
        uploadView.addButton.addTarget(self, action: #selector(SetProfilePictureViewController.chooseDisplayPic(_:)), forControlEvents: .TouchUpInside)
        
        
    }
    
    func chooseDisplayPic(sender: AnyObject) {
        
        let chooseSource: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            
            
        }
        chooseSource.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Default)
        { action -> Void in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        }
        chooseSource.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default)
        { action -> Void in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
            
        }
        chooseSource.addAction(deleteActionButton)
        self.presentViewController(chooseSource, animated: true, completion: nil)
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
