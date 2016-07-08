//
//  MyLifeContainerViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 07/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MyLifeContainerViewController: UIViewController {
    
    @IBOutlet weak var TheScrollView: UIScrollView!
    
    var verticalLayout: VerticalLayout!
    internal var whichView: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.verticalLayout = VerticalLayout(width: self.view.frame.width - 30);

        let postOne = InProfileOTGPost(frame: CGRect(x: 8, y: 8, width: verticalLayout.frame.width - 10, height: 500))
        postOne.clipsToBounds = true
        postOne.statusLabel.text = "Manan Vora ended his London Journey"
        postOne.iconButtonView.removeFromSuperview()
        

        let postTwo = NewProfilePosts(frame: CGRect(x: 8, y: 0, width: verticalLayout.frame.width - 10, height: 800))
        postTwo.clipsToBounds = true

        let postThree = NewThoughtsView(frame: CGRect(x: 8, y: 0, width: verticalLayout.frame.width - 10, height: 350))
        postThree.clipsToBounds = true
        
        switch whichView {
        case "All":
            self.addHeightToLayout(postOne.frame.height)
            verticalLayout.addSubview(postOne)
            self.addHeightToLayout(postTwo.frame.height)
            verticalLayout.addSubview(postTwo)
            self.addHeightToLayout(postThree.frame.height)
            verticalLayout.addSubview(postThree)
            break
            
        case "TL":
            self.addHeightToLayout(postOne.frame.height)
            verticalLayout.addSubview(postOne)
            break
            
        case "LL":
            self.addHeightToLayout(postTwo.frame.height)
            verticalLayout.addSubview(postTwo)
            self.addHeightToLayout(postThree.frame.height)
            verticalLayout.addSubview(postThree)
            break
            
        default:
            break
        }
        
        TheScrollView.contentSize.height = verticalLayout.frame.height + 100
        TheScrollView.addSubview(verticalLayout)
        
        verticalLayout.userInteractionEnabled = false
        
    }
    
    func addHeightToLayout(height: CGFloat) {
        
        verticalLayout.frame.size.height += height
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
