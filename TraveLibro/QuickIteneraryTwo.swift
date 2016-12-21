//
//  QuickIteneraryTwo.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 07/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickIteneraryTwo: UIViewController {
    @IBOutlet var typeButton: [UIButton]!
    
    
    var eachButton: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        quickItinery["itineraryType"] = []
        
        let array = ["adventure", "business", "family", "budget", "backpacking", "romance", "friends", "religious", "luxury"]
        if quickItinery["itineraryType"] == nil {
            quickItinery["itineraryType"] = JSON(eachButton)
        }
        
        for eachButton in typeButton {
            
            eachButton.addTarget(self, action: #selector(typeButtonPressed(_:)), for: .touchUpInside)
            
        }

        for button in typeButton {
            
            let index = typeButton.index(of: button)
            button.setTitle(array[index!], for: .application)
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(quickItinery)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func typeButtonPressed(_ sender: UIButton!){
        if sender.tag == 0 {
            sender.setBackgroundImage(UIImage(named: "orangebox"), for: .normal)
            eachButton.append(sender.title(for: .application)!)
            
            sender.tag = 1
        }
        else {
            sender.setBackgroundImage(UIImage(named: "bluebox"), for: .normal)
            eachButton = eachButton.filter({$0 != sender.currentTitle})
            sender.tag = 0
            
        }
        quickItinery["itineraryType"] = JSON(eachButton)
    }

}
