//
//  ActivityFeedsController.swift
//  TraveLibro
//
//  Created by Jagruti  on 17/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityFeedsController: UIViewController {

    @IBOutlet weak var activityScroll: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getActivity(pageNumber: 1)
    }
    
    func getActivity(pageNumber: Int) {
        request.getActivityFeeds(currentUser["_id"].stringValue, pageNumber: pageNumber, completion: {(request) in
            print(request)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
