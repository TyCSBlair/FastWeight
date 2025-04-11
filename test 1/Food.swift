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
    let brandOwner: String
    let servingSize: Float
    let servingSizeUnit: String
    let foodNutrients: [Nutrient]
}

struct FoodsResponse : Hashable, Codable {
    let foods: [Food]
}

struct Nutrient: Hashable, Codable {
    let nutrientId: Int
    let value: Float
}

