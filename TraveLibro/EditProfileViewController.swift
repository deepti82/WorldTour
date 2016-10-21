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
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "profilePhotoCell") as! ProfilePhotoTableViewCell
            cell.accessoryType = .none
            return cell
            
        }
        
        else if (indexPath as NSIndexPath).section == 1 || (indexPath as NSIndexPath).section == 6 || (indexPath as NSIndexPath).section == 7 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditLabelCell") as! EditProfileTableViewCell
            cell.editLabel.text = labels[(indexPath as NSIndexPath).section]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        else if (indexPath as NSIndexPath).section == 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditNationalityCell") as! EditProfileTableViewCell
            cell.editLabel.text = labels[(indexPath as NSIndexPath).section]
            cell.accessoryType = .disclosureIndicator
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell") as! TextFieldTableViewCell
        cell.textField.text = labels[(indexPath as NSIndexPath).section]
        cell.textField.delegate = self
        cell.textField.contentVerticalAlignment = .center
        cell.textField.returnKeyType = .done
        cell.accessoryType = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("jewjkhwerkjhwerkhwer")
        textField.resignFirstResponder()
        return false
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if !keyboardUp {
                
                self.view.frame.origin.y -= keyboardSize.height
                keyboardUp = true
                
            }
            
            
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if keyboardUp {
                
                self.view.frame.origin.y += keyboardSize.height
                keyboardUp = false
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        myView = tableView.indexPathForSelectedRow!.section
        
        switch (indexPath as NSIndexPath).section {
        case 0:
//            let moveAndScaleVC = storyboard?.instantiateViewControllerWithIdentifier("") as! SetProfilePictureViewController
//            self.navigationController?.pushViewController(moveAndScaleVC, animated: true)
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                
                
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default)
            { action -> Void in
                
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
            actionSheetControllerIOS8.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default)
            { action -> Void in
                
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
                
                
            }
            actionSheetControllerIOS8.addAction(deleteActionButton)
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        case 1, 7, 6:
            let otherSettingsVC = storyboard?.instantiateViewController(withIdentifier: "EditEdit") as! EditEditProfileViewController
            otherSettingsVC.whichView = (indexPath as NSIndexPath).section
            self.navigationController?.pushViewController(otherSettingsVC, animated: true)
            break
        
//        case 2:
//            becomeFirstResponder()
//            break
            
        case 5:
            let nationalityVC = storyboard?.instantiateViewController(withIdentifier: "SelectCountryVC") as! SelectCountryViewController
            nationalityVC.whichView = "selectNationality"
            self.navigationController?.pushViewController(nationalityVC, animated: true)
            break
            
        default:
            break
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).section == 0 {
            
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
