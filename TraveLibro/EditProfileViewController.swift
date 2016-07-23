//
//  EditProfileViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 06/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var editTableViewCell: UITableView!
    let labels = ["Profile Photo", "16 Jan 1988", "Yash Chudasama", "Dream Destination", "Favourite City", "Nationality", "City", "Male"]
    var myView: Int = 0
    let imagePicker = UIImagePickerController()
    var keyboardUp = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("profilePhotoCell") as! ProfilePhotoTableViewCell
            cell.accessoryType = .None
            return cell
            
        }
        
        else if indexPath.section == 1 || indexPath.section == 6 || indexPath.section == 7 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("EditLabelCell") as! EditProfileTableViewCell
            cell.editLabel.text = labels[indexPath.section]
            cell.accessoryType = .DisclosureIndicator
            return cell
        }
        
        else if indexPath.section == 5 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("EditNationalityCell") as! EditProfileTableViewCell
            cell.editLabel.text = labels[indexPath.section]
            cell.accessoryType = .DisclosureIndicator
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell") as! TextFieldTableViewCell
        cell.textField.text = labels[indexPath.section]
        cell.textField.delegate = self
        cell.textField.contentVerticalAlignment = .Center
        cell.textField.returnKeyType = .Done
        cell.accessoryType = .None
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        print("jewjkhwerkjhwerkhwer")
        textField.resignFirstResponder()
        return false
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        textField.resignFirstResponder()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if !keyboardUp {
                
                self.view.frame.origin.y -= keyboardSize.height
                keyboardUp = true
                
            }
            
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if keyboardUp {
                
                self.view.frame.origin.y += keyboardSize.height
                keyboardUp = false
                
            }
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        myView = tableView.indexPathForSelectedRow!.section
        
        switch indexPath.section {
        case 0:
//            let moveAndScaleVC = storyboard?.instantiateViewControllerWithIdentifier("") as! SetProfilePictureViewController
//            self.navigationController?.pushViewController(moveAndScaleVC, animated: true)
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                
                
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Default)
            { action -> Void in
                
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .Camera
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
                
            }
            actionSheetControllerIOS8.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default)
            { action -> Void in
                
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
                
                
            }
            actionSheetControllerIOS8.addAction(deleteActionButton)
            self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)
        case 1, 7, 6:
            let otherSettingsVC = storyboard?.instantiateViewControllerWithIdentifier("EditEdit") as! EditEditProfileViewController
            otherSettingsVC.whichView = indexPath.section
            self.navigationController?.pushViewController(otherSettingsVC, animated: true)
            break
        
//        case 2:
//            becomeFirstResponder()
//            break
            
        case 5:
            let nationalityVC = storyboard?.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
            nationalityVC.whichView = "selectNationality"
            self.navigationController?.pushViewController(nationalityVC, animated: true)
            break
            
        default:
            break
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 8
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 75
        }
        
        return 50
        
    }
    
//    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        
//        if listItems != nil {
//            listItems?.text = textField.text
//        }
//        return true
//        
//    }
}


class EditProfileTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var editLabel: UILabel!
    
    
}

class ProfilePhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
}

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
}