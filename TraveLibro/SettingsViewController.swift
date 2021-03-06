//
//  SettingTableViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    internal var labels = ["Cellular and WiFi", "WiFi", "Cellular"]
    
    @IBOutlet weak var heightConstraintTable: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        let count: CGFloat = CGFloat(labels.count)
        heightConstraintTable.constant = count * 75
        print("NSLayoutConstraint: \(heightConstraintTable)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labels.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell") as! EditSettingsTableViewCell
        cell.checkLabel.text = labels[indexPath.item]
        //cell.checkButton.setTitle(String(format: "%C", (faicon["check"])!), forState: .Normal)
        //ell.bringSubviewToFront(cell.checkButton)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if selectedCell?.accessoryType == .Checkmark {
            
            selectedCell?.accessoryType = .None
        }
        
        else {
            
            selectedCell?.accessoryType = .Checkmark
        }
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if selectedCell?.accessoryType == .Checkmark {
            
            selectedCell?.accessoryType = .None
        }
        
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
