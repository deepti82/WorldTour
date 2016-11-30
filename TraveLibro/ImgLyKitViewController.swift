//
//  ImgLyKitViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 23/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ImgLyKitViewController: UIViewController {
    
    var currentImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        reloadRec()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        reloadRec()
    }
    
    func reloadRec(){
        let videoURL = NSURL(string: "file:///private/var/mobile/Containers/Data/Application/AA25F723-BD36-4680-8A35-087A50407CBD/tmp/58FCD2A3-8326-4958-91B6-5CD698EF0B54-31427-0000074F8CC5CE61.mov")
        let player = AVPlayer(url: videoURL! as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
