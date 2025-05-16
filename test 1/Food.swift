//
//  Food.swift
//  test 1
//
//  Created by Ty Blair on 4/1/25.
//

import Foundation

struct Food : Hashable, Codable {
    let fdcId: Int
    let description: String
    let dataType: String
    let brandOwner: String?
    let servingSize: Float?
    let servingSizeUnit: String?
    let foodNutrients: [Nutrient]
    let foodMeasures: [FoodPortion]?
}

struct FoodsResponse : Hashable, Codable {
    let foods: [Food]
}

struct Nutrient: Hashable, Codable {
    let nutrientId: Int
    let value: Float
}

struct FoodPortion: Hashable, Codable {
    let disseminationText: String
    let gramWeight: Float
}

struct identifiableFoodPortion: Hashable, Identifiable {
    let id: Int
    let disseminationText: String
    let gramWeight: Float
}

func portionsToIdentifiable(portions: [FoodPortion]) -> [identifiableFoodPortion] {
    var newList: [identifiableFoodPortion] = []
    var id: Int = 0
    for i in portions {
        newList.append(identifiableFoodPortion(id:id, disseminationText: i.disseminationText, gramWeight: i.gramWeight))
        id += 1
    }
    return newList
}

func identifiableToFoodPortion(portion: identifiableFoodPortion) -> FoodPortion {
    let newPortion: FoodPortion = FoodPortion(disseminationText: portion.disseminationText, gramWeight: portion.gramWeight)
    return newPortion
}

