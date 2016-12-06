//
//  Structures.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 26/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation

struct PhotoUpload {
    
    var localId: Int64
    var caption: String
    var serverId: String
    var url: String
}

struct UserLocation {
    var latitude: String
    var longitude: String
}
