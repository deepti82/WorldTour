//
//  PhotosOTGController.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 29/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PhotosOTGController: UIViewController {

    var photoHeader = PhotosOTGHeader()
    var photoCenter = PhotosOTGView()
    var photoFooter = PhotoOTGFooter()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoHeader = PhotosOTGHeader(frame: CGRect(x: 0, y: -2, width: 400, height: 184))
                
        photoCenter = PhotosOTGView(frame: CGRect(x: 0, y: 198, width: 400, height: 394))
        
        photoFooter = PhotoOTGFooter(frame: CGRect(x: 0, y: 593, width: 400, height: 184))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
