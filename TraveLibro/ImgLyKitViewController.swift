//
//  ImgLyKitViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 23/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import imglyKit

class ImgLyKitViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadRec()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        reloadRec()
    }
    
    func reloadRec(){
//        let imgSample = UIImage(named:"add_profile_pic")
//        let configuration = Configuration() { builder in
//            builder.backgroundColor = UIColor.clear
//            builder.configureCameraViewController(){ cameraConf in
//                cameraConf.allowedRecordingModes = [.photo]
//                cameraConf.maximumVideoLength = 6
//                cameraConf
//            }
//        
////            builder.configureToolStackController(){toolSck in
////                toolSck.accessibilityNavigationStyle = .automatic
////                addLeftBarButtonWithImage(imgSample!)
////            }
//        }
//        let cameraViewController = CameraViewController(configuration:configuration)
//        present(cameraViewController, animated: true, completion: {data in
//            print(data)
//        })
        
        
        let sampleImage = UIImage(named: "add_profile_pic")
        let photoEditViewController = PhotoEditViewController(photo: sampleImage!)
        tool
        let toolStackController = ToolStackController(photoEditViewController: photoEditViewController)
        toolStackController.navigationItem.title = "Editor"
        toolStackController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: photoEditViewController, action: "cancel:")
        toolStackController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: photoEditViewController, action: "save:")
        
//        toolStackController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: toolStackController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barStyle = .black
        
        present(navigationController, animated: true, completion: nil)

    }
    
    
    
    
//    private func customizeCameraController(builder: ConfigurationBuilder) {
//        builder.configureCameraViewController { options in
//            // Enable/Disable some features
//            options.maximumVideoLength = 15
//            options.showFilterIntensitySlider = false
//            options.tapToFocusEnabled = false
//            
//            // Use closures to customize the different view elements
//            //            options.videoRecordingStartedHandler = { rec in
//            //                print("clicked")
//            //                print(rec)
//            //            }
//            options.cameraRollButtonConfigurationClosure = { button in
//                button.layer.borderWidth = 2.0
//                button.layer.borderColor =  UIColor.red.cgColor
//            }
//            
//            options.timeLabelConfigurationClosure = { label in
//                label.textColor = UIColor.red
//            }
//            
//            options.recordingModeButtonConfigurationClosure = { button, _ in
//                button.setTitleColor(UIColor.gray, for: .normal)
//                button.setTitleColor(UIColor.red, for: .selected)
//            }
//            
//            // Force a selfie camera
//            options.allowedCameraPositions = [ .front ]
//            
//            // Disable flash
//            options.allowedFlashModes = [ .off ]
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
