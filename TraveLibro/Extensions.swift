//
//  Extensions.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 01/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation

extension String {
    
    func index(of string: String, options: String.CompareOptions = .literal) -> String.Index? {
        return range(of: string, options: options, range: nil, locale: nil)?.lowerBound
    }
    
    func indexes(of string: String, options: String.CompareOptions = .literal) -> [String.Index] {
        var result: [String.Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex, locale: nil) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    
    func ranges(of string: String, options: String.CompareOptions = .literal) -> [Range<String.Index>] {
        var result: [Range<String.Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex, locale: nil) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
}

