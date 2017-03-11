//
//  UIViewControllerExtension.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/2/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    func getRatingImage(rate:String) -> JSON {
        switch rate {
        case "1":
            return ["image":"disapointed","back":"orangebox"]
        case "2":
            return ["image":"sad","back":"orangebox"]
        case "3":
            return ["image":"good","back":"orangebox"]
        case "4":
            return ["image":"superface","back":"orangebox"]
        case "5":
            return ["image":"love","back":"orangebox"]
        default:
            return ["image":"star_rate_icon","back":"orangebox"]
        }
    }
    
}


