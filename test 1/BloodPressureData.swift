//
//  BloodPressureData.swift
//  test 1
//
//  Created by Ty Blair on 4/23/25.
//

import Foundation
import SwiftData

@Model
public class BloodPressureData: Identifiable {
    var bpId: Int
    var systolic: Int
    var diastolic: Int
    var date: Date
 
    init(bpId: Int, systolic: Int, diastolic: Int, date: Date) {
        self.bpId = bpId
        self.systolic = systolic
        self.diastolic = diastolic
        self.date = date
    }
}
