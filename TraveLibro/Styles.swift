//
//  Styles.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


func addShadow(myView: UIView, offset: CGSize, opacity: CGFloat, shadowRadius: CGFloat, cornerRadius: CGFloat) {
    
    myView.layer.shadowOffset = CGSize(width: 2, height: 2)
    myView.layer.shadowOpacity = 0.2
    myView.layer.shadowRadius = 1
    myView.layer.cornerRadius = 3
    
}

func makeButtonGreyTranslucent(button: UIButton, textData: String) -> Void {
    
    button.backgroundColor = UIColor(red: 189/255, green: 193/255, blue: 211/255, alpha: 0.3)
    button.layer.borderColor = UIColor.whiteColor().CGColor
    button.layer.borderWidth = 2
    button.layer.cornerRadius = 1.5
    //button.titleLabel?.text = "Hii Midhet"
    //button.titleLabel?.textColor = UIColor.whiteColor()
    button.setTitle(textData, forState: .Normal)
    button.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 18)
    
}