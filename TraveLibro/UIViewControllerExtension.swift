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
            return ["image":"disapointed","back":"green_bg_new_small"]
        case "2":
            return ["image":"sad","back":"green_bg_new_small"]
        case "3":
            return ["image":"good","back":"green_bg_new_small"]
        case "4":
            return ["image":"superface","back":"green_bg_new_small"]
        case "5":
            return ["image":"love","back":"green_bg_new_small"]
        default:
            return ["image":"star_rate_icon","back":"orangebox_shadow"]
        }
    }
    
}


