//
//  EditProfileViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 06/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class EditProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var editTableViewCell: UITableView!
    let labels = ["Profile Photo", "16 Jan 1988", "Yash Chudasama", "Dream Destination", "Favourite City", "Nationality", "Male"]
    var myView: Int = 0
    let imagePicker = UIImagePickerController()
    var keyboardUp = false
    var pickerImage: UIImage?
    var currentTextField:UITextField?
    var datePickerView: UIDatePicker!
    
    private var shouldSave  = true
    
    var editedValues: [String: Any] = [:]
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        genderValue = ""
        imagePicker.delegate = self       
//        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editTableViewCell.reloadData()
        shouldSave = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if shouldSave == true{
            saveAll()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:-  Table View Datasource and Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {    //Profile photo
            let cell = tableView.dequeueReusableCell(withIdentifier: "profilePhotoCell") as! ProfilePhotoTableViewCell
            if pickerImage != nil {
                cell.profilePhoto.image = pickerImage
            }
            else{
                cell.profilePhoto.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])", width: 100))
            }
            cell.accessoryType = .none
            return cell
            
        }
            
        else if (indexPath as NSIndexPath).section == 1 {   //DOB
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateTypeTextFieldCell") as! DateTypeTextFieldTableViewCell
            cell.datetypeTextField.delegate = self
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"                
            let date = dateFormatter.date(from: currentUser["dob"].stringValue)
            if date != nil {
                dateFormatter.dateFormat = "dd MMM yyyy"
                cell.datetypeTextField.text = dateFormatter.string(from: date! as Date);                
            }
            
            
            if cell.datetypeTextField.text == "" {
                let dateFormatter = DateFormatter()
                let dateObj = NSDate()
                dateFormatter.dateFormat = "dd MMM yyyy"
                cell.datetypeTextField.text = dateFormatter.string(from: dateObj as Date);
            }
            
            cell.datetypeTextField.contentVerticalAlignment = .center
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        else if (indexPath as NSIndexPath).section == 6 {    //Gender
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditLabelCell") as! EditProfileTableViewCell
            cell.editLabel.text = labels[(indexPath as NSIndexPath).section]
            if genderValue == "" {
                genderValue = currentUser["gender"].stringValue                
            }
            
            cell.editLabel.text = genderValue.capitalized
            
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        else if (indexPath as NSIndexPath).section == 4 || (indexPath as NSIndexPath).section == 5 {    //Nationality || City
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditNationalityCell") as! EditProfileTableViewCell
            cell.editLabel.text = labels[(indexPath as NSIndexPath).section]
            cell.accessoryType = .disclosureIndicator
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell") as! TextFieldTableViewCell
        cell.textField.text = labels[(indexPath as NSIndexPath).section]
        if indexPath.section == 2 { //Name
            cell.textField.text = currentUser["name"].stringValue
            cell.textField.tag = 33
        }
        else if indexPath.section == 3 {
            cell.textField.tag = 35
        }
        cell.textField.delegate = self
        cell.textField.contentVerticalAlignment = .center
        cell.textField.returnKeyType = .done
        cell.accessoryType = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        myView = tableView.indexPathForSelectedRow!.section
        switch (indexPath as NSIndexPath).section {
        case 0:
            //            let moveAndScaleVC = storyboard?.instantiateViewControllerWithIdentifier("") as! SetProfilePictureViewController
            //            self.navigationController?.pushViewController(moveAndScaleVC, animated: true)
            
            shouldSave = false
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                self.shouldSave = true
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
        
        case 4: //City
            shouldSave = false
            let cityVC = self.storyboard!.instantiateViewController(withIdentifier: "addCity") as! AddCityViewController
            cityVC.isFromSettings = true
            self.navigationController?.pushViewController(cityVC, animated: true)
            break
            
        case 5: //Nationality
            shouldSave = false
            let nationality = storyboard?.instantiateViewController(withIdentifier: "nationalityNew") as!AddNationalityNewViewController
            nationality.isFromSettings = true
            self.navigationController?.pushViewController(nationality, animated: true)
            break
            
        case 6: //Gender
            shouldSave = false
            let otherSettingsVC = storyboard?.instantiateViewController(withIdentifier: "EditEdit") as! EditEditProfileViewController
            otherSettingsVC.whichView = (indexPath as NSIndexPath).section
            self.navigationController?.pushViewController(otherSettingsVC, animated: true)
            break
            
        default:
            break
        }
        
        self.editTableViewCell.deselectRow(at: indexPath, animated: true)
        
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
    
    
    //MARK: - Text Field Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 35 {
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {        
        if textField.tag == 34 {
            currentTextField = textField
            self.datetypeTextFieldSelected(textField)
        }       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {        
        textField.resignFirstResponder()
        if textField.tag == 33 {
            
            if textField.text != "" {
                
                let userName = textField.text!
                if userName != currentUser["name"].stringValue {
                    editedValues["name"] = userName                    
                }                
            } else {
                alert(message: "Please Select City.", title: "Select City")
            }
        }
    }
    
    
    //MARK: - Notification for Keyboard Handler
    
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
    
    
    //MARK: - Image Picker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("\n\n Info : \(info)")
        
        var pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        if pickedImage != nil {
            pickerImage = pickedImage
        }
        else{
            pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            if pickedImage != nil {
                pickerImage = pickedImage
            }
        }
        
        if pickerImage != nil {
            Toast(text: "Please wait while uploading profile image...").show()            
            let newProfilePicImgURL = "file://" + NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/profileimage.jpg"            
            DispatchQueue.main.async(execute: {
                do {
                    if let data = UIImageJPEGRepresentation(self.pickerImage!, 0.35) {
                        try data.write(to: URL(string: newProfilePicImgURL)!, options: .atomic)
                        
                        request.uploadPhotos(URL(string: newProfilePicImgURL)!, localDbId: 0, completion: {(response) in
                            if response["value"] == true {
                                self.editedValues["profilePicture"] = response["data"][0].stringValue
                                if let currentToast = ToastCenter.default.currentToast {
                                    currentToast.cancel()
                                }
                                Toast(text: "Profile image uploaded").show()
                            }
                        })
                    }
                } catch let error as NSError {
                    
                    print("error uploading profile picture: \(error.localizedDescription)")
                    
                }
                
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Date Picker Delegate
    
    @IBAction func datetypeTextFieldSelected(_ sender: UITextField) {
        sender.inputAccessoryView = createPickerToolBar()
        
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.backgroundColor = UIColor.white
        
        //setting Default Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"        
        let date = dateFormatter.date(from: sender.text!)
        datePickerView.date = date!
        datePickerView.maximumDate = NSDate() as Date        
        sender.inputView = datePickerView
    }
    
    func createPickerToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonTabbed(sender:)))        
        doneButton.accessibilityLabel = "DoneToolbar"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelButtonTabbed(sender:)))        
        cancelButton.accessibilityLabel = "DoneToolbar"
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.isTranslucent = false
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.barTintColor = mainBlueColor
        
        return toolbar
    }
    
    @IBAction func doneButtonTabbed(sender: UIButton) {
        currentTextField?.resignFirstResponder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        currentTextField?.text = dateFormatter.string(from: datePickerView.date as Date)        
        editedValues["dob"] = currentTextField?.text
        currentTextField = nil
    }
    
    @IBAction func cancelButtonTabbed(sender: UIButton) {
        currentTextField?.resignFirstResponder()
        currentTextField = nil
    }
    
    
    //MARK:- Sync with server
    
    func saveAll() {
        
        
        if genderValue != currentUser["gender"].stringValue {
            editedValues["gender"] = genderValue            
        }
        
        if !(editedValues.isEmpty) {
            
            editedValues["_id"] = currentUser["_id"].stringValue
            print("Edited Values dict : \(editedValues)")
            
            DispatchQueue.global().async {
                request.bulkEditUser(params: self.editedValues) { (response) in            
                    currentUser = response["data"]                
                    DispatchQueue.main.async {
                        self.editTableViewCell.reloadData()
                        ToastCenter.default.cancelAll()
                        Toast(text: "Profile updated").show()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentUserUpdated"), object: nil)
                    }
                }
            }
        }
    }
    
}    



    //MARK: - Custom Cell Definations

class EditProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var editLabel: UILabel!
}

class ProfilePhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePhoto: UIImageView!
}

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
}

class DateTypeTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var datetypeTextField: UITextField!
}

