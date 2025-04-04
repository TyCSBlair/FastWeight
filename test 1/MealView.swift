//
//  MealView.swift
//  test 1
//
//  Created by Ty Blair on 3/14/25.
//

import SwiftUI

struct MealView: View {
    var body: some View {
        Text("meal test")
        MoveButtonView(buttonttext: "search for food", buttondestination: FoodFinderView())
    }
}

#Preview {
    MealView()
}
