//
//  ConfigModel.swift
//  TraveLibro
//
//  Created by Chintan Shah on 15/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//



import UIKit

class Config {
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
    
}

