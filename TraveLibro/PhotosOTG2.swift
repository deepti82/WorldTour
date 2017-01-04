//
//  OnlyPhoto.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 18/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PhotosOTG2: VerticalLayout {

    var photosOtgHeader:PhotosOTGHeader!

    func generatePost(_ post:Post) {
        photosOtgHeader = PhotosOTGHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 120 ))
            self.addSubview(photosOtgHeader)
    }
}
