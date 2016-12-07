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
    
    @IBOutlet weak var nextButton: UIButton!
    
    var eachButton: [String] = []
    var quickItinery: JSON = ["title": "", "year": "", "month": "", "duration": "", "itenaryType": ""]

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 5
        
        let array = ["adventure", "business", "family", "romance", "backpacking", "budget", "luxury", "religious", "friends"]
        
        quickItinery["itenaryType"] = JSON(eachButton)
        for eachButton in typeButton {
            
            eachButton.addTarget(self, action: #selector(typeButtonPressed(_:)), for: .touchUpInside)
            
        }

        for button in typeButton {
            
            let index = typeButton.index(of: button)
            button.setTitle(array[index!], for: .application)
            
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func typeButtonPressed(_ sender: UIButton!){
        if sender.tag == 0 {
            print("backgroundchange: \(sender.currentTitle)")
            sender.setBackgroundImage(UIImage(named: "orangebox"), for: .normal)
            eachButton.append(sender.title(for: .application)!)
            
            sender.tag = 1
        }
        else {
            sender.setBackgroundImage(UIImage(named: "bluebox"), for: .normal)
            eachButton = eachButton.filter({$0 != sender.currentTitle})
            sender.tag = 0
            
        }
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
