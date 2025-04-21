//
//  FastData.swift
//  test 1
//
//  Created by Ty Blair on 4/14/25.
//

import Foundation
import SwiftData

@Model
class FastData {
    var fastStartTime: Date
    var fastDuration: Int
    
    init(fastStartTime: Date, fastDuration: Int) {
        self.fastStartTime = fastStartTime
        self.fastDuration = fastDuration
    }
}
