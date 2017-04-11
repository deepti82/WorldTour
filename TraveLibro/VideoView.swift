//
//  PhotosOTGHeader.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 28/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Player

class VideoView: UIView {
    @IBOutlet weak var videoHolder: UIImageView!
    var player:Player!
    var defaultMute = true
    @IBOutlet weak var toggleSound: UIButton!
    @IBOutlet weak var tagText: UILabel!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var playBtn: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        tagView.clipsToBounds = true
        tagView.layer.cornerRadius = 5

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "VideoView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        toggleSound.setTitle(String(format: "%C",0xf026) + "⨯", for: UIControlState())
        toggleSound.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        toggleSound.clipsToBounds = true
        toggleSound.layer.cornerRadius = 5
        
    }
    
    @IBAction func toggleSoundTap(_ sender: Any) {
        if(defaultMute) {
            defaultMute = false;
            player.muted = defaultMute
            toggleSound.setTitle(String(format: "%C",0xf028), for: UIControlState())
        } else {
            defaultMute = true;
            player.muted = defaultMute
            toggleSound.setTitle(String(format: "%C",0xf026) + "⨯", for: UIControlState())
        }
    }
}

