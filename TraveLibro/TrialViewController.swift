//
//  TrialViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 18/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class TrialViewController: UIViewController {

    @IBOutlet weak var newImage: UIImageView!
    var singleMustDo: JSON! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(singleMustDo)
        
//        let image = UIImage(named: "disney_world")
//        let maskingImage = UIImage(named: "profile_mask.png")
//        newImage.image = maskImage(image!, mask: maskingImage!)
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(scrollView)
        
        scrollView.contentSize.height = 800
        
        let mustDoDescription = EachMustDo(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollView.contentSize.height))
        mustDoDescription.titleImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: singleMustDo["mainPhoto"].string!)!)!)
        mustDoDescription.descriptionText.text = singleMustDo["description"].string!
        scrollView.addSubview(mustDoDescription)
    
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
    
    func maskImage(image:UIImage, mask:(UIImage))->UIImage{
        
        let imageReference = image.CGImage
        let maskReference = mask.CGImage
        
        let imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                          CGImageGetHeight(maskReference),
                                          CGImageGetBitsPerComponent(maskReference),
                                          CGImageGetBitsPerPixel(maskReference),
                                          CGImageGetBytesPerRow(maskReference),
                                          CGImageGetDataProvider(maskReference), nil, true)
        
        let maskedReference = CGImageCreateWithMask(imageReference, imageMask)
        
        let maskedImage = UIImage(CGImage:maskedReference!)
        
        return maskedImage
    }

}
