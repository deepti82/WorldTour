//
//  TLPostUploadServerHelper.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 05/06/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

protocol TLUploadingItemDelegate {
    func itemUploadedSuccessfully(itemId: String)
    func itemUploadingFailed(itemId: String)
}

class TLPostUploadServerHelper: NSObject {
    
    var postUploadManagerSharedInstance: TLPostUploadServerHelper!
    var postItemUploadDelegate: TLUploadingItemDelegate?    
    
    private var uploadingRequestQueue: Array<NSMutableDictionary>!
    
    
    func uploadPostSharedManager() -> TLPostUploadServerHelper {
        
        if postUploadManagerSharedInstance == nil {
            postUploadManagerSharedInstance = TLPostUploadServerHelper()
        }
        return postUploadManagerSharedInstance
    }
    
    
    
    
    

}
