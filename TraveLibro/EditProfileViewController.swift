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
    let labels = ["Profile Photo", "16 Jan 1988", "Yash Chudasama", "Favourite Destination -  ", "Where Do You Live?", "Nationality", "Male"]
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
        
        getDarkBackGround(self)
        genderValue = ""
        imagePicker.delegate = self
        editTableViewCell.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editTableViewCell.reloadData()
        shouldSave = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if shouldSave == true {
            DispatchQueue.main.async(execute: {
                self.saveAll()                
            })            
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).section == 0 {
            
            return 75
        }
        
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {    //Profile photo
            let cell = tableView.dequeueReusableCell(withIdentifier: "profilePhotoCell") as! ProfilePhotoTableViewCell
            makeTLProfilePicture(cell.profilePhoto)
            if pickerImage != nil {
                cell.profilePhoto.image = pickerImage
            }
            else{
                cell.profilePhoto.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])", width: 80))
            }
            cell.accessoryType = .none
            return cell
            
        }
            
        else if (indexPath as NSIndexPath).section == 1 {   //DOB
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateTypeTextFieldCell") as! DateTypeTextFieldTableViewCell
            cell.datetypeTextField.delegate = self
            cell.datetypeTextField.text = ""
                            
            let date = currentUser["dob"].string
            if date != nil { 
                cell.datetypeTextField.text = getDateFormat(date!, format: "dd MMM yyyy")                
            }
            
            if cell.datetypeTextField.text == "" {                
                cell.datetypeTextField.text = "Birthdate"
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
        
        else if (indexPath as NSIndexPath).section == 4 {    //City
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditNationalityCell") as! EditProfileTableViewCell
            cell.editLabel.text = "\(labels[(indexPath as NSIndexPath).section]) - \(currentUser["homeCity"].stringValue)"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
            
        else if (indexPath as NSIndexPath).section == 5 {    //Nationality
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditNationalityCell") as! EditProfileTableViewCell
            cell.editLabel.text = "\(labels[(indexPath as NSIndexPath).section]) - \(currentUser["homeCountry"]["name"].stringValue)"
            cell.accessoryType = .disclosureIndicator
            return cell            
        }
        
        else if (indexPath as NSIndexPath).section == 3 {    //Favourite Destination
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "destinationCell") as! DestinationTextFieldCell
            
            let paddingView = UILabel(frame: CGRect(x: 5, y: 0, width: 150, height: cell.destinationTextField.frame.size.height))
            paddingView.text = labels[(indexPath as NSIndexPath).section]
            paddingView.textColor = mainBlueColor
            paddingView.font = avenirBold
            paddingView.textAlignment = .left
            cell.destinationTextField.leftView = paddingView
            cell.destinationTextField.leftViewMode = UITextFieldViewMode.always            
            cell.destinationTextField.text = currentUser["dream_destination"].stringValue
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch (indexPath as NSIndexPath).section {
        case 0:
            
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
                self.imagePicker.navigationBar.isTranslucent = true
                self.imagePicker.navigationBar.barTintColor = mainBlueColor
                self.imagePicker.navigationBar.tintColor = UIColor.white
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
            }
        }
        else if textField.tag == 28 {
            
            if textField.text != "" {
                
                let destination = textField.text!
                if destination != currentUser["dream_destination"].stringValue {
                    editedValues["dream_destination"] = destination                    
                }                
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
            let loader = LoadingOverlay()
            loader.showOverlay(self.view)
            let newProfilePicImgURL = "file://" + NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/profileimage.jpg"            
            DispatchQueue.main.async(execute: {                
                do {
                    if let data = UIImageJPEGRepresentation(self.pickerImage!, 0.35) {
                        try data.write(to: URL(string: newProfilePicImgURL)!, options: .atomic)
                        
                        request.uploadPhotos(URL(string: newProfilePicImgURL)!, localDbId: 0, completion: {(response) in
                            if response["value"] == true {
                                request.editUser(currentUser["_id"].stringValue, editField: "profilePicture", editFieldValue: response["data"][0].stringValue, completion: { (newResponse) in
                                    DispatchQueue.main.async {
                                        loader.hideOverlayView()
                                        print("\n NewResponse : \(newResponse)")
                                        if response["value"] == true {
                                            currentUser = newResponse["data"]
                                            isSettingsEdited = true
                                        }
                                    }
                                })
                            }
                            else{
                                print("Error in uploading profile photo ")
                                loader.hideOverlayView()
                            }
                        })
                    }
                } catch let error as NSError {
                    loader.hideOverlayView()
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
        var date = dateFormatter.date(from: sender.text!)
        if sender.text == "Birthdate" {
           date =  NSDate() as Date
        }                
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
            
            isSettingsEdited = true
            
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

class DestinationTextFieldCell : UITableViewCell, UITextFieldDelegate{
    @IBOutlet weak var destinationTextField: UITextField!
    
}

