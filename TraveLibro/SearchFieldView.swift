//
//  SearchFieldView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SearchFieldView: UIView {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var SearchView: UIView!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        transparentCardWhite(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SearchFieldView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    @IBAction func onSearch(_ sender: UITextField) {
        print(searchField.text!)
        if searchField.text! == "" {
            globalMainSearchViewController.changeView(switchView: "slider")
        }else{
            globalMainSearchViewController.changeView(switchView: "table")
        }
    }
    

}
