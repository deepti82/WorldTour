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
    
    open class Loader {
    
        var loader = UIView()
        var imageView1 = UIImageView()
        
        class var shared: LoadingOverlay {
            struct Static {
                static let instance: LoadingOverlay = LoadingOverlay()
            }
            return Static.instance
        }
        
        func showOverlay(_ view: UIView) {
            hideOverlayView()
            print("show loader")
            loader = UIView(frame:CGRect(x: 0, y: 0, width: 100, height: 100))
            view.addSubview(loader)
            loader.center = view.center
            let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//            imageView1.backgroundColor = UIColor.white
            imageView1.image = UIImage.gif(name: "loader")
            imageView1.contentMode = .scaleAspectFit
            loader.addSubview(imageView1)
            
        }
        
        func hideOverlayView() {
            
            print("hide overlay")
            if loader != nil {
            loader.removeFromSuperview()
            }else {
                //
            }
        }
        
    }
}
