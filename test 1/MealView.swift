//
//  MealView.swift
//  test 1
//
//  Created by Ty Blair on 3/14/25.
//

import SwiftUI
import SwiftData

struct MealView: View {
    @State var selecteddate: Date = Date()
    @Query private var StoredFoods: [StoredFood]
    @Query private var diet: [Macros]
    @Environment(\.modelContext) private var context2
    var body: some View {
        @State var StoredFoods2: [StoredFood] = makeNewList(foods: StoredFoods, date: selecteddate)
        VStack{
            Text("Daily Meals").font(.largeTitle)
            HStack{
                DatePicker("Select Date: ", selection:$selecteddate, displayedComponents: .date).padding(.trailing, -5.0).labelsHidden()
                Text("'s Food").font(.title).multilineTextAlignment(.leading)
                            
            }
            
            
            LazyVGrid(columns:[GridItem(), GridItem(), GridItem()]){
                Text("Food Name")
                Text("Servings")
                Text("Total Calories")
            }
            Divider()
                .padding(.horizontal)
            ScrollView{
                
                ScrollViewReader{ reader in
                    LazyVGrid(columns:[GridItem(), GridItem(), GridItem()]){
                        
                        ForEach(StoredFoods2){ food in
                            HStack{
                                Button(action:{
                                    context2.delete(StoredFoods[findFoodIndex(foods: StoredFoods, id: food.id)])
                                }){
                                    Image(systemName: "trash")
                                }
                                Text(food.name)
                                    .multilineTextAlignment(.center)
                                    
                            }
                            
                            Menu{
                                ForEach (1...10, id:\.self){ serving in
                                    Button(action:{
                                        let tempFood: StoredFood = food
                                        context2.delete(StoredFoods[findFoodIndex(foods: StoredFoods, id: food.id)])
                                        context2.insert(servingMutator(food: tempFood, newServings: Float(serving)))
                                    }){
                                        Text(serving.description)
                                    }
                                }
                            }label:{Text(String(food.servingsConsumed))
                                .multilineTextAlignment(.center)}
                            .padding()
                            Text(String(Float(findCalories(nutrients: food.foodNutrients))!*food.servingsConsumed))
                                .multilineTextAlignment(.center)
                        }
                    }.onChange(of: StoredFoods2){ reader.scrollTo(0)
                    }
                }

            }
            Divider()
                .padding(.horizontal)
            LazyVGrid(columns:[GridItem(), GridItem(), GridItem(), GridItem()]){
                Text("Total Calories")
                Text("Total Fats")
                Text("Total Carbs")
                Text("Total Protein")
            }
            Divider()
                .padding(.horizontal)
            LazyVGrid(columns:[GridItem(), GridItem(), GridItem(), GridItem()]){
                let fat = findTotalNutrient(foods: StoredFoods2, nutrientId: 1004)
                let carbs = findTotalNutrient(foods: StoredFoods2, nutrientId: 1005)
                let protein = findTotalNutrient(foods: StoredFoods2, nutrientId: 1003)
                let calories = findTotalCalories(foods: StoredFoods2)
                calorieGoalpopup(goal:String(diet.first?.calories ?? 0), label: Text("\(String(calories))kcal").foregroundStyle(checkAgainstMacros(value1: Double(calories), value2: Double(diet.first?.calories ?? 0))))
                nutrientGoalpopup(nutrient: "Fat", goal:String(format: "%.01f",(diet.first?.calories ?? 0)*(Float(diet.first?.fat ?? 0)/100)/9), label: Text("\(String(format: "%.01f", fat))g").foregroundStyle(checkAgainstMacros(value1: Double(fat) * 9, value2: (Double(diet.first?.fat ?? 0)/100)*Double(diet.first?.calories ?? 0))))
                nutrientGoalpopup(nutrient: "Carb", goal:String(format: "%.01f",(diet.first?.calories ?? 0)*(Float(diet.first?.carbohydrates ?? 0)/100)/4), label: Text("\(String(format: "%.01f", carbs))g").foregroundStyle(checkAgainstMacros(value1: Double(carbs) * 4, value2: (Double(diet.first?.carbohydrates ?? 0)/100)*Double(diet.first?.calories ?? 0))))
                nutrientGoalpopup(nutrient: "Protein", goal:String(format: "%.01f",(diet.first?.calories ?? 0)*(Float(diet.first?.protein ?? 0)/100)/4), label: Text("\(String(format: "%.01f", protein))g").foregroundStyle(checkAgainstMacros(value1: Double(protein) * 4, value2: (Double(diet.first?.protein ?? 0)/100)*Double(diet.first?.calories ?? 0))))
            }
            
            Spacer()
            
            MoveButtonView(buttonttext: "Search For Food", buttondestination: FoodFinderView(selecteddate: $selecteddate))
        }
        
    }
}

struct nutrientGoalpopup: View {
    @State private var showPopup: Bool = false
    var nutrient: String
    var goal: String?
    var label: Text
    var body: some View {
        Button(action:{showPopup.toggle()}){label}.popover(isPresented: $showPopup) {
            Text("\(nutrient) goal: \(String(format: "%.1f", Double(goal ?? "0")!))g").padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).presentationCompactAdaptation(.popover)
        }
    }
}

struct calorieGoalpopup: View {
    @State private var showPopup: Bool = false
    var goal: String
    var label: Text
    var body: some View {
        Button(action:{
            showPopup.toggle()
        }){label}.popover(isPresented: $showPopup) {
            Text("Calorie goal: \(goal)kcal").padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).presentationCompactAdaptation(.popover)}
            
        }
}


func checkAgainstMacros(value1: Double, value2: Double) -> Color{
    if value1 >= value2 * 0.6 {
        if value1 >= value2 * 0.8 {
            if value1 > value2 * 1.2 {
                return .purple
            }  
            return .green
        }
        return .orange
    }
    
    return .red
}

func findFoodIndex(foods: [StoredFood], id: Int) -> Int{
    var index: Int = 0
    for i in foods.indices {
        if foods[i].id == id{
            index = i
        }
    }
    return index
}

func checkDates(date1: Date, date2: Date)->Bool{
    if Calendar.current.isDate(date1, equalTo: date2, toGranularity: .day){
        return true
    }
    return false
}

func makeNewList(foods: [StoredFood], date: Date)->[StoredFood]{
    var newList: [StoredFood] = []
    for i in foods {
        if checkDates(date1:i.dateStored, date2: date){
            newList.append(i)
        }
    }
    return newList
}

func findTotalCalories(foods: [StoredFood]) -> Float {
    var totalcal: Float = 0
    for i in foods {
        totalcal = Float(findCalories(nutrients: i.foodNutrients))!*i.servingsConsumed + totalcal
    }
    return totalcal
}

// calories = 1008, protein = 1003, total lipids = 1004, carbs = 1005, fiber = 1079
func findTotalNutrient(foods: [StoredFood], nutrientId: Int) -> Float {
    var totalcal: Float = 0
    for i in foods {
        totalcal = findNutrient(nutrients: i.foodNutrients, nutrientId: nutrientId)*i.servingsConsumed + totalcal
    }
    return totalcal
}

#Preview {
    MealView().modelContainer(for:[StoredFood.self, Macros.self], inMemory: true)
}
