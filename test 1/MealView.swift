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
                Text(String(findTotalCalories(foods: StoredFoods2)))+Text("kcal")
                Text(String(format: "%.02f", findTotalNutrient(foods: StoredFoods2, nutrientId: 1004)))+Text("g")
                Text(String(format: "%.02f", findTotalNutrient(foods: StoredFoods2, nutrientId: 1005)))+Text("g")
                Text(String(format: "%.02f", findTotalNutrient(foods: StoredFoods2, nutrientId: 1003)))+Text("g")
            }
            
            Spacer()
            
            MoveButtonView(buttonttext: "Search For Food", buttondestination: FoodFinderView(selecteddate: $selecteddate))
        }
        
    }
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
func findTotalNutrient(foods: [StoredFood], nutrientId: Int) -> Float {
    var totalcal: Float = 0
    for i in foods {
        totalcal = findNutrient(nutrients: i.foodNutrients, nutrientId: nutrientId)*i.servingsConsumed + totalcal
    }
    return totalcal
}

#Preview {
    MealView().modelContainer(for:StoredFood.self, inMemory: true)
}
