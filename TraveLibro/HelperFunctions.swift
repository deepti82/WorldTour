//
//  helperFunctions.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 8/26/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

func verifyUrl (urlString: String?) -> Bool {
    
    if let urlString = urlString {
        
        if let url = NSURL(string: urlString) {
            
            return UIApplication.sharedApplication().canOpenURL(url)
        }
    }
    return false
}
