//
//  LoadingOverlay.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/24/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    open class LoadingOverlay {
    
        var loader = UIView()
        var imageView1 = UIImageView()
        
        class var shared: LoadingOverlay {
            struct Static {
                static let instance: LoadingOverlay = LoadingOverlay()
            }
            return Static.instance
        }
        
        func showOverlay(_ view: UIView) {
            
            print("show loader")
            loader = UIView(frame:CGRect(x: 100, y: 200, width: view.frame.size.width/2, height: view.frame.size.height/2))
            view.addSubview(loader)
            let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/2, height: view.frame.size.height/2))
//            imageView1.backgroundColor = UIColor.white
            imageView1.image = UIImage.gif(name: "loader")
            imageView1.contentMode = .center
            loader.addSubview(imageView1)
            
        }
        
        func hideOverlayView() {
            
            print("hide overlay")
            
            loader.removeFromSuperview()
        }
        
    }
}
