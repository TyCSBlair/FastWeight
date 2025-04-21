//
//  FoodFinderView.swift
//  test 1
//
//  Created by Ty Blair on 4/1/25.
//

import SwiftUI
import SwiftData

struct FoodFinderView: View {
    
    @State private var searchText: String = ""
    @State private var storedSearchText: String = ""
    @State private var foodItems: [Food] = []
    @State private var page: Int = 1
    @State private var showNextButton: Bool = false
    @State private var showPreviousButton: Bool = false
    @Binding var selecteddate: Date
    var body: some View {
        VStack() {
            Text("Food Search").font(.largeTitle).padding(.bottom)
            HStack(spacing: 5.0){
                Text("Search:")
                    
                TextField(text:$searchText, prompt: Text("Input Food Item")){
                }.frame(width:150)
                .padding(.leading)
                ZStack(){
//                    RoundedRectangle(cornerRadius: 5).frame(width: 95, height: 30).foregroundStyle(Color.teal)
                    Button("Search",systemImage: "magnifyingglass",action:{
                        Task{
                            page = 1
                            storedSearchText = searchText
                            foodItems = await getFoodData(searchText: searchText, page: page)
                            showNextButton = true
                            showPreviousButton = false
                        }
                    })
                }
            }
            Divider()
                .padding(.horizontal)
            LazyVGrid(columns:[GridItem(), GridItem()]){
                            Text("Food Name")
                            Text("Brand")
            }
            Divider()
                .padding(.horizontal)
            ScrollView{
                LazyVGrid(columns:[GridItem(), GridItem()]){
                                ForEach(foodItems, id: \.self){foodItem in
//                                    Text(foodItem.description).foregroundStyle(.secondary).frame(height: 30).onTapGesture {
//                                        popupView(foodItem: foodItem)
//                                    }
                                    popupView(label: foodItem.description, foodItem: foodItem, date: selecteddate)
                                        .padding(.leading)
//                                    Text(foodItem.brandOwner).foregroundStyle(.secondary).onTapGesture {
//                                        popupView(foodItem: foodItem)
//                                    }
                                    popupView(label: foodItem.brandOwner, foodItem: foodItem, date: selecteddate)
                                        .padding(.trailing)
                                }
                            }
                Spacer()
                
            }
            Divider()
            HStack{
                if showNextButton {
                                Button("Next Page"){
                                                   Task{
                                                       foodItems = await getFoodData(searchText: storedSearchText, page: page+1)
                                                       page = page+1
                                                       showPreviousButton = true
                                                   }
                                               }
                                           }
                                           if showPreviousButton {
                                               Button("Previous Page"){
                                                   Task{
                                                       foodItems = await getFoodData(searchText: storedSearchText, page: page-1)
                                                       page = page-1
                                                       if page == 1 {
                                                           showPreviousButton = false
                                                       }
                                                   }
                                               }
                                           }
            }
            .frame(height: /*@START_MENU_TOKEN@*/15.0/*@END_MENU_TOKEN@*/)
           
            
        }
        
        
        Spacer()
        
    }
}

var APIkey: String = "XBE7L00LGr70XHL9IbbPfSBorCMSYewbaC5nbgKo"

func buildUrl (searchText: String, pageNumber: Int) -> String {
    let newText  = searchText.replacingOccurrences(of: " ", with: "%20")
    print(newText)
    let endURL : String = "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=\(APIkey)&query=\(newText)&pageSize=20&pageNumber=\(pageNumber)&sortBy=dataType.keyword"
    print(endURL)
    return endURL
}

func getFoodData(searchText: String, page: Int) async -> [Food] {
    var newFoodItems: [Food] = []
    
    guard let newFoodItems2: FoodsResponse = await WebService().downloadData(fromURL: buildUrl(searchText: searchText, pageNumber: page)) else {
        return newFoodItems
    }
    newFoodItems = newFoodItems2.foods
    return newFoodItems
}

func findCalories(nutrients: [Nutrient]) -> String {
    var calories : Float = 0
    for i in nutrients {
        if i.nutrientId == 1008 {
            calories = Float(i.value)
        }
    }
    return String(calories)
}
// calories = 1008, protein = 1003, total lipids = 1004, carbs = 1005, fiber = 1079
func findNutrient(nutrients: [Nutrient], nutrientId: Int) -> Float {
    var nutrient : Float = 0
    for i in nutrients {
        if i.nutrientId == nutrientId {
            nutrient = Float(i.value)
        }
    }
    return nutrient
}



struct popupView: View {
    @State private var showPopup: Bool = false
    @Query private var StoredFoods: [StoredFood]
    @Environment(\.modelContext) private var context2
    @State private var servings: Int = 1
    var label: String
    var foodItem: Food
    var date: Date
    var body: some View {
        Button(label){showPopup.toggle()}.frame(height: 50)
            .popover(isPresented: $showPopup) {
                VStack(alignment: .leading){
                        Text("Food Name: \(foodItem.description)").frame(height: 50)
                        Text("Brand Name: \(foodItem.brandOwner)").frame(height: 50)
                        Text("Serving Size: \(String(foodItem.servingSize))\(foodItem.servingSizeUnit)").frame(height: 20)
                        Text("Calories: \(findCalories(nutrients: foodItem.foodNutrients))").frame(height: 20)
                    
                    HStack{
                        Picker ("Servings had:", selection: $servings){
                            ForEach (1...10, id: \.self){ value in
                                Text(value.description)
                            }
                        }.frame(width: 70)
                        Button(action:{
                            context2.insert(foodToStoredFood(id: findNewId(foods: StoredFoods), date: date, food: foodItem, servings: Float(servings)))
                            showPopup = false
                        }){
                            RoundedRectangle(cornerRadius: 10).frame(width:90, height: 30).foregroundStyle(.blue).overlay(Text("Add Food").foregroundStyle(.white))
                        }
                        
                    }
                    }.padding().presentationCompactAdaptation(.popover)
            }
    }
}
func findNewId(foods: [StoredFood]) -> Int {
    var newid: Int = 0
    for i in foods{
        if i.id >= newid{
            newid = i.id + 1
        }
    }
    return newid
}

#Preview {
    struct Preview: View{
        @State var fakedate: Date = Date()
        var body: some View {
            FoodFinderView(selecteddate: $fakedate)
                    .modelContainer(for: StoredFood.self, inMemory: true)
        }
    }
    return Preview()
}
