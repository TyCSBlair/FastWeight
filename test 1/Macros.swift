//
//  Macros.swift
//  test 1
//
//  Created by Ty Blair on 4/16/25.
//

import Foundation
import SwiftData

@Model
class Macros {
    var protein: Double
    var carbohydrates: Double
    var fat: Double
    var calories: Float
    
    init(protein: Double, carbohydrates: Double, fat: Double, calories: Float) {
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.calories = calories
    }
    
    
}
