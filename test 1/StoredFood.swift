//
//  StoredFood.swift
//  test 1
//
//  Created by Ty Blair on 4/9/25.
//

import Foundation
import SwiftData

@Model
class StoredFood: Identifiable {
    var id: Int
    var dateStored: Date
    var fdcId: Int
    var name: String
    var brandOwner: String
    var servingSize: Int
    var servingSizeUnit: String
    var foodNutrients: [Nutrient]
    var servingsConsumed: Float
    
    init(id: Int, dateStored: Date, fdcId: Int, name: String, brandOwner: String, servingSize: Int, servingSizeUnit: String, foodNutrients: [Nutrient], servingsConsumed: Float) {
        self.id = id
        self.dateStored = dateStored
        self.fdcId = fdcId
        self.name = name
        self.brandOwner = brandOwner
        self.servingSize = servingSize
        self.servingSizeUnit = servingSizeUnit
        self.foodNutrients = foodNutrients
        self.servingsConsumed = servingsConsumed
    }
    
}

func foodToStoredFood(id:Int, date: Date, food: Food, servings: Float) -> StoredFood{
    var newFood: StoredFood
    newFood = StoredFood(id: id, dateStored: date, fdcId: food.fdcId, name: food.description, brandOwner: food.brandOwner, servingSize: food.servingSize, servingSizeUnit: food.servingSizeUnit, foodNutrients: food.foodNutrients, servingsConsumed: servings)
    return newFood
}

func servingMutator(food: StoredFood, newServings: Float) -> StoredFood{
    let newFood: StoredFood = StoredFood(id: food.id, dateStored: food.dateStored, fdcId: food.fdcId, name: food.name, brandOwner: food.brandOwner, servingSize: food.servingSize, servingSizeUnit: food.servingSizeUnit, foodNutrients: food.foodNutrients, servingsConsumed: newServings)
    return newFood
}
