//
//  VideoViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 29/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: AVPlayerViewController {
    
    var filepath:URL? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
//        let videoURL = NSURL(URL: filepath)
        let player = AVPlayer(url: filepath!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }


        // Do any additional setup after loading the view.
    }

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
