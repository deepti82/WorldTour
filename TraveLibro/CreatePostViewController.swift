//
//  CreatePostViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 25/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: .normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        
        let postButton = UIButton()
        postButton.setTitle("Post", for: .normal)
        //postButton.addTarget(self, action: #selector(self.newPost(_:)), for: .touchUpInside)
        postButton.titleLabel!.font = UIFont(name: "Avenir-Roman", size: 16)

        self.customNavigationBar(left: nil, right: postButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popVC() {
        //self.navigation
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
