//
//  SettingTableViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    internal var dataSourceOption: String = ""
    internal var labels = ["Cellular and WiFi", "WiFi", "Cellular"]
    
    @IBOutlet weak var heightConstraintTable: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        let count: CGFloat = CGFloat(labels.count)
        heightConstraintTable?.constant = count * 75
        print("NSLayoutConstraint: \(heightConstraintTable)")
        
        if dataSourceOption == "dataUploadOptions" {
            labels = ["Cellular and WiFi", "WiFi", "Cellular"]
        }
        else {
            labels = ["Public - Everyone", "Private - My Followers"]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labels.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! EditSettingsTableViewCell
        cell.checkLabel.text = labels[(indexPath as NSIndexPath).item]
        //cell.checkButton.setTitle(String(format: "%C", (faicon["check"])!), forState: .Normal)
        //ell.bringSubviewToFront(cell.checkButton)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        if selectedCell?.accessoryType == .checkmark {
            
            selectedCell?.accessoryType = .none
        }
        
        else {
            
            selectedCell?.accessoryType = .checkmark
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        if selectedCell?.accessoryType == .checkmark {
            
            selectedCell?.accessoryType = .none
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if dataSourceOption == "privacyOptions" {
            let footerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
            footerLabel.text = "When you select your account to be private only, your followers can view your My Life - Journeys, Moments abd Reviews."
            footerLabel.textAlignment = .center
            footerLabel.numberOfLines = 0
            footerLabel.lineBreakMode = .byWordWrapping
            return footerLabel
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
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

class EditSettingsTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkLabel: UILabel!
    
//    @IBAction func optionChecked(sender: UIButton) {
//        
//        if sender.titleLabel!.tintColor == mainOrangeColor {
//            
//         sender.titleLabel!.tintColor = UIColor.lightGrayColor()
//            
//        }
//        
//        else {
//            
//            sender.titleLabel!.tintColor = mainOrangeColor
//        }
//    }
    
}
