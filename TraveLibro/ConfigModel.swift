//
//  ConfigModel.swift
//  TraveLibro
//
//  Created by Chintan Shah on 15/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//



import UIKit
import Foundation

public class Config {
    func changeDateFormat(_ givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = getFormat
        
        if isDate {
            
            dateFormatter.dateStyle = .medium
            
        }
        
        let goodDate = dateFormatter.string(from: date!)
        return goodDate
        
    }
    
    func setVC(newViewController : UIViewController) {
        
        let nvc = UINavigationController(rootViewController: newViewController)
        leftViewController.mainViewController = nvc
        leftViewController.slideMenuController()?.changeMainViewController(leftViewController.mainViewController, close: true)
        
        UIViewController().customiseNavigation()
        nvc.delegate = UIApplication.shared.delegate as! UINavigationControllerDelegate?
    }
    
    func getHeight(ht:Double) -> Double {
        if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
            return ht
        }else{
            return ht - 65
        }
    }

    
}

