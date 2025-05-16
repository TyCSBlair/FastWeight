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
    var dataType: String
    var brandOwner: String
    var servingSize: Float
    var servingSizeUnit: String
    var foodNutrients: [Nutrient]
    var foodPortions: [FoodPortion] = []
    var servingsConsumed: Float
    var portion: FoodPortion = FoodPortion(disseminationText: "", gramWeight: 0)
    
    init(id: Int, dateStored: Date, fdcId: Int, name: String, dataType: String, brandOwner: String, servingSize: Float, servingSizeUnit: String, foodNutrients: [Nutrient], servingsConsumed: Float, foodPortions: [FoodPortion], portion: FoodPortion) {
        self.id = id
        self.dateStored = dateStored
        self.fdcId = fdcId
        self.name = name
        self.dataType = dataType
        self.brandOwner = brandOwner
        self.servingSize = servingSize
        self.servingSizeUnit = servingSizeUnit
        self.foodNutrients = foodNutrients
        self.servingsConsumed = servingsConsumed
        self.foodPortions = foodPortions
        self.portion = portion
    }
    
}

func foodToStoredFood(id:Int, date: Date, food: Food, servings: Float, portion: FoodPortion?) -> StoredFood{
    var newFood: StoredFood
    
    if food.dataType == "Branded"{
        newFood = StoredFood(id: id, dateStored: date, fdcId: food.fdcId, name: food.description, dataType:food.dataType, brandOwner: food.brandOwner ?? "", servingSize: food.servingSize ?? 0, servingSizeUnit: food.servingSizeUnit ?? "", foodNutrients: food.foodNutrients, servingsConsumed: servings, foodPortions: food.foodMeasures ?? [], portion: portion ?? FoodPortion(disseminationText: "", gramWeight: 0))
    } else {
        newFood = StoredFood(id: id, dateStored: date, fdcId: food.fdcId, name: food.description, dataType:food.dataType, brandOwner: food.brandOwner ?? "", servingSize: portion?.gramWeight ?? 0, servingSizeUnit: food.servingSizeUnit ?? "g", foodNutrients: food.foodNutrients, servingsConsumed: servings, foodPortions: food.foodMeasures ?? [], portion: portion ?? FoodPortion(disseminationText: "", gramWeight: 0))
    }

    return newFood
}

func servingMutator(food: StoredFood, newServings: Float) -> StoredFood{
    let newFood: StoredFood = StoredFood(id: food.id, dateStored: food.dateStored, fdcId: food.fdcId, name: food.name, dataType:food.dataType, brandOwner: food.brandOwner, servingSize: food.servingSize, servingSizeUnit: food.servingSizeUnit, foodNutrients: food.foodNutrients, servingsConsumed: newServings, foodPortions: food.foodPortions, portion: food.portion)
    return newFood
}
