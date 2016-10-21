//
//  PopularAgents.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 10/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PopularAgents: UIView {

    @IBOutlet weak var agentPicture: UIImageView!
    @IBOutlet weak var theStack: UIStackView!
    @IBOutlet weak var itineraries: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var agentLocation: UILabel!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var followbutton: UIButton!
    @IBOutlet weak var FooterView: UIView!
    @IBOutlet weak var TitleView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let gradient = CAGradientLayer()
        _ = CAGradientLayer()
        
        let blackColour = UIColor.black.withAlphaComponent(0.8).cgColor as CGColor
        let transparent = UIColor.clear.cgColor as CGColor
        
        gradient.frame = TitleView.bounds
        gradient.frame.size.width = TitleView.frame.width + 100
        gradient.colors = [blackColour, transparent]
        gradient.locations = [0.0, 0.5]
        
        TitleView.layer.addSublayer(gradient)
        
        
        TitleView.bringSubview(toFront: followbutton)
        TitleView.bringSubview(toFront: agentName)
        TitleView.bringSubview(toFront: agentLocation)
        
//        gradientTwo.frame = FooterView.bounds
//        gradientTwo.frame.size.width = FooterView.frame.width + 100
//        gradientTwo.colors = [transparent, blackColour]
//        gradientTwo.locations = [0.0, 0.5]
//        
//        FooterView.layer.addSublayer(gradientTwo)
//        
//        FooterView.bringSubviewToFront(theStack)
//        FooterView.bringSubviewToFront(agentPicture)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PopularAgents", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
