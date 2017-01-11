//
//  previewBase.swift
//  TraveLibro
//
//  Created by Jagruti  on 10/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class previewBase: UIView {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var backGreen: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        self.backView.layer.cornerRadius = 5
        self.backView.clipsToBounds = true
        backGreen.layer.shadowColor = UIColor.black.cgColor
        backGreen.layer.shadowOpacity = 0.5
        backGreen.layer.shadowOffset = CGSize.zero
        backGreen.layer.shadowRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "previewBase", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    

}
