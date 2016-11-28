//
//  ImgLyKitViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 23/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import imglyKit

class ImgLyKitViewController: UIViewController,ToolStackControllerDelegate {
    
    var currentImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        reloadRec()
        
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
        
        print("current image")
        print(currentImage)
        let photoEditViewController = PhotoEditViewController(photo: currentImage)
        let toolStackController = ToolStackController(photoEditViewController: photoEditViewController)
        toolStackController.delegate = self
        toolStackController.navigationItem.title = "Editor"
        
        toolStackController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: photoEditViewController, action: #selector(ImgLyKitViewController.cancel(_:)))
        
        toolStackController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: photoEditViewController, action: #selector(PhotoEditViewController.save(_:)))
        
        let navigationController = UINavigationController(rootViewController: toolStackController)
        
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barStyle = .black
        
        present(navigationController, animated: true, completion: nil)

    }
    
    
    func toolStackController(_ toolStackController: ToolStackController, didFinishWith image: UIImage){
        
        print("in tool stack ctrl")
        print(image)
            self.currentImage = image
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addCaptions = storyboard.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
        addCaptions.currentImage = image
        self.navigationController?.present(addCaptions, animated: true, completion: nil)
        }
    
    func toolStackControllerDidCancel(_ toolStackController: ToolStackController){
        print("on cancel toolstackcontroller")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        
//        let imgLyKit = storyboard.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
//        self.present(imgLyKit, animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion:nil)

    }
    
    func toolStackControllerDidFail(_ toolStackController: ToolStackController){
        print("on fail toolstackcontroller")
    }
    
    func cancel(_ sender: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            
//            if segue.identifier == "goBackCaption" {
//                
//                let photoGrid = segue.destination as! AddCaptionsViewController
//                photoGrid.currentImage = currentImage
//                
//            }
//        }
    
}
