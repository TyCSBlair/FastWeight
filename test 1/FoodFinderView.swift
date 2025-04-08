//
//  FoodFinderView.swift
//  test 1
//
//  Created by Ty Blair on 4/1/25.
//

import SwiftUI

struct FoodFinderView: View {
    @State private var searchText: String = ""
    @State private var storedSearchText: String = ""
    @State private var foodItems: [Food] = []
    @State private var page: Int = 1
    @State private var showNextButton: Bool = false
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
                                    popupView(label: foodItem.description, foodItem: foodItem)
                                        .padding(.leading)
//                                    Text(foodItem.brandOwner).foregroundStyle(.secondary).onTapGesture {
//                                        popupView(foodItem: foodItem)
//                                    }
                                    popupView(label: foodItem.brandOwner, foodItem: foodItem)
                                        .padding(.trailing)
                                }
                            }
                Spacer()
                if showNextButton {
                    Divider()
                        .padding(.horizontal)
                    Button("Next Page"){
                        Task{
                            foodItems = await getFoodData(searchText: storedSearchText, page: page+1)
                            page = page+1
                            
                        }
                    }
                }
            }
            
            
        }
        
        
        Spacer()
        
    }
}

var APIkey: String = "XBE7L00LGr70XHL9IbbPfSBorCMSYewbaC5nbgKo"

func buildUrl (searchText: String, pageNumber: Int) -> String {
    let newText  = searchText.replacingOccurrences(of: " ", with: "%20")
    print(newText)
    let endURL : String = "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=\(APIkey)&query=\(newText)&pageNumber=\(pageNumber)&sortBy=dataType.keyword"
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



struct popupView: View {
    @State var showPopup: Bool = false
    var label: String
    var foodItem: Food
    var body: some View {
        Button(label){showPopup.toggle()}.frame(height: 50)
            .popover(isPresented: $showPopup) {
                VStack(alignment: .leading){
                        Text("Food Name: \(foodItem.description)").frame(height: 50)
                        Text("Brand Name: \(foodItem.brandOwner)").frame(height: 50)
                        Text("Serving Size: \(String(foodItem.servingSize))\(foodItem.servingSizeUnit)").frame(height: 20)
                        Text("Calories: \(findCalories(nutrients: foodItem.foodNutrients))").frame(height: 20)
                    }.padding().presentationCompactAdaptation(.popover)
            }
    }
}

#Preview {
    FoodFinderView()
}
