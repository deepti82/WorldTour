//
//  ListPhotosViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ListPhotosViewController: UIViewController {
    
    var layout: VerticalLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBackGround(self)
        
        layout = VerticalLayout(width: self.view.frame.width - 40)
        
        let scroll = UIScrollView(frame: self.view.frame)
        self.view.addSubview(scroll)
        scroll.showsVerticalScrollIndicator = false
        scroll.addSubview(layout)
        
        let profileImage = UIImageView(frame: CGRect(x: 0, y: 85, width: 100, height: 100))
        profileImage.center.x = self.view.frame.width/2
        profileImage.image = UIImage(named: "profile_pic_new")
        layout.addSubview(profileImage)
        
        for i in 0 ..< 6 {
            
            addPhoto(i)
            
        }
        
//        let ratingOne = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingOne.frame.height)
//        layout.addSubview(ratingOne)
//        
//        let ratingTwo = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingTwo.frame.height)
//        layout.addSubview(ratingTwo)
//        
//        let ratingThree = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingThree.frame.height)
//        layout.addSubview(ratingThree)
//        
//        let ratingFour = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingFour.frame.height)
//        layout.addSubview(ratingFour)
//        
//        let ratingFive = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingFive.frame.height)
//        layout.addSubview(ratingFive)
//        
//        let ratingSix = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingSix.frame.height)
//        layout.addSubview(ratingSix)
        
        scroll.contentSize.height = layout.frame.height
    }
    
    func addHeightToLayout(height: CGFloat) {
        
        layout.frame.size.height += height + 100
        
    }
    
    func addPhoto(count: Int) {
        
        let photo = PhotoList(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 415))
        addHeightToLayout(photo.frame.height)
        layout.addSubview(photo)
        
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
