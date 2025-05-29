//
//  Weight.swift
//  test 1
//
//  Created by Ty Blair on 3/17/25.
//

import Foundation
import SwiftData

@Model
class Weight : Identifiable {
    var id: Int
    var weightvalue: Float = 150
    var datetaken: Date = Date()
    
    init(id: Int, weightvalue: Float, datetaken: Date) {
        self.id = id
        self.weightvalue = weightvalue
        self.datetaken = datetaken
    }
}
