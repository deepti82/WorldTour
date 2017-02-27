//
//  SearchElement.swift
//  TraveLibro
//
//  Created by Jagruti  on 24/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class SearchElement: UIView {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageLable: UILabel!
    var index = ""
    var feeds:JSON = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
<<<<<<< HEAD
        loadViewFromNib ()
        
        
        
        
//        let tapRecognizer = UITapGestureRecognizer()
//        tapRecognizer.numberOfTapsRequired = 1
//        tapRecognizer.addTarget(self, action: #selector(self.toggleFullscreen))
//        self.image.addGestureRecognizer(tapRecognizer)
=======
        loadViewFromNib ()        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.addTarget(self, action: #selector(self.toggleFullscreen))
        self.image.addGestureRecognizer(tapRecognizer)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
>>>>>>> origin/level-3-
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SearchElement", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func setData(data:JSON, tabs:String) {
        print("set data clicked")
        feeds = data
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.toggleFullscreen(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func toggleFullscreen(_ sender: AnyObject){
        print("clicked....")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let controller = storyboard.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
        controller.fromOutSide = feeds["_id"].stringValue
        controller.fromType = feeds["type"].stringValue
        
        print(feeds["_id"])
        print(feeds["type"])

        globalNavigationController.pushViewController(controller, animated: true)
        
    }
}
