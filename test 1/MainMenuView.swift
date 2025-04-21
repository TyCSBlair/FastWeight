//
//  MainMenuView.swift
//  test 1
//
//  Created by Ty Blair on 3/13/25.
//

import SwiftUI
import Charts
import SwiftData

struct MainMenuView: View {
    var body: some View {
        NavigationStack{
            VStack {
                Text("FastWeight").font(.largeTitle)
                Spacer()
                weightChart()
                    .padding(.horizontal)
                    .frame(height: 150.0)
                Text("Weight Tracker").font(.caption).padding(.bottom)
                ScrollView {
                    macrosNotification()
                    Text("Daily Macros").font(.caption).padding(.bottom)
                    fastSchedule()
                    Text("Fast Schedule").font(.caption).padding(.bottom)
                        
                    MoveButtonView(buttonttext:"Record Weight", buttondestination: WeightView())
                    MoveButtonView(buttonttext:"Record Meal", buttondestination: MealView())
                    MoveButtonView(buttonttext:"Set Macro Goals", buttondestination: DietView())
                    MoveButtonView(buttonttext:"Set Fasting Schedule", buttondestination: FastView())
                }
            }
            .padding()    }
    }
}

struct weightChart: View {
    @Query private var weights: [Weight]
    var body: some View {
        
        Chart(weights.sorted(by:{$0.datetaken < $1.datetaken})){
            LineMark(
                x: .value("Date", $0.datetaken),
                y: .value("Weight", $0.weightvalue)
            ).foregroundStyle(.green)
        }.chartYScale(domain: [findMinWeight(weights: weights) - 10, findMaxWeight(weights: weights) + 10])
    }
}

struct macrosNotification: View {
    @Query var macros: [Macros]
    @Query var storedFoods: [StoredFood]
    var body: some View {
        @State var storedFoods2: [StoredFood] = makeNewList(foods: storedFoods, date: Date())
        let totalCalories: Float = findTotalCalories(foods: storedFoods2)
        let totalFat: Float = findTotalNutrient(foods: storedFoods2, nutrientId: 1004)
        let totalCarbs: Float = findTotalNutrient(foods: storedFoods2, nutrientId: 1005)
        let totalProtein: Float = findTotalNutrient(foods: storedFoods2, nutrientId: 1003)
        let fatGoal: Double = (Double((macros.first?.calories ?? 0))*((macros.first?.fat ?? 0)/100))/9
        let carbGoal: Double = (Double((macros.first?.calories ?? 0))*((macros.first?.carbohydrates ?? 0)/100))/4
        let proteinGoal: Double = (Double((macros.first?.calories ?? 0))*((macros.first?.protein ?? 0)/100))/4
        let calorieGoal: Float = macros.first?.calories ?? 0
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()]){
            Text("Calories")
            Text("Fat")
            Text("Carbs")
            Text("Protein")
        }
        Divider()
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()]){
            calorieGoalpopup(goal: String(calorieGoal), label:
                                Text("\(String(format: "%.1f", totalCalories))kcal").foregroundStyle(checkAgainstMacros(value1: Double(totalCalories), value2: Double(calorieGoal)))
            )
            nutrientGoalpopup(nutrient: "Fat", goal: String(fatGoal), label:(
                Text("\(String(format: "%.1f", totalFat))g").foregroundStyle(checkAgainstMacros(value1: Double(totalFat), value2: Double(fatGoal)))
            ))
            nutrientGoalpopup(nutrient: "Carbs", goal: String(carbGoal), label:(
                Text("\(String(format: "%.1f", totalCarbs))g").foregroundStyle(checkAgainstMacros(value1: Double(totalCarbs), value2: Double(carbGoal)))
            ))
            nutrientGoalpopup(nutrient: "Protein", goal: String(proteinGoal), label:(
                Text("\(String(format: "%.1f", totalProtein))g").foregroundStyle(checkAgainstMacros(value1: Double(totalProtein), value2: Double(proteinGoal)))
            ))
        }
    }
}

struct fastSchedule: View {
    @Query private var fastData: [FastData]
    var body: some View {
        let FastHours: Int = fastData.first?.fastDuration ?? 0
        let FastStartDate: Date = fastData.first?.fastStartTime ?? Date()
        let HoursLeft: Int = Int(hoursElapsed(startDate: Date(), currentDate: Date(timeInterval:Double(FastHours) * 3600, since:FastStartDate)))
        ZStack{
            Rectangle().foregroundStyle(.gray)
            if fastData.isEmpty {
                Text("Not Currently Fasting")
            } else {
                if HoursLeft < 0 {
                    Text("Fast Over!")
                } else {
                    Text("Hours Left in Fast: \(HoursLeft)")
                }
        }
            
        }.frame(width: 300)
    }
}

func findMinWeight( weights: [Weight]) -> Int {
    var minWeight: Int = 1000
    for i in weights {
        if i.weightvalue < minWeight {
            minWeight = i.weightvalue
        }
    }
    return minWeight
}

func findMaxWeight( weights: [Weight]) -> Int {
    var maxWeight: Int = 0
    for i in weights {
        if i.weightvalue > maxWeight {
            maxWeight = i.weightvalue
        }
    }
    return maxWeight
}

#Preview {
    MainMenuView()
        .modelContainer(for: [Weight.self, Macros.self, StoredFood.self, FastData.self], inMemory: true)
}
