//
//  GlucoseData.swift
//  test 1
//
//  Created by Ty Blair on 4/25/25.
//

import Foundation
import SwiftData

@Model

class GlucoseData: Identifiable {
    var gId: Int
    var date: Date
    var glucose: Double
    
    init(gId: Int, date: Date, glucose: Double) {
        self.gId = gId
        self.date = date
        self.glucose = glucose
    }
}
