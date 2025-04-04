//
//  FoodFinderView.swift
//  test 1
//
//  Created by Ty Blair on 4/1/25.
//

import SwiftUI

struct FoodFinderView: View {
    @State private var searchText: String = ""
    @State private var foodItems: [Food] = []
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
                            foodItems = await getFoodData(searchText: searchText)
                        }
                    })
                }
            }
            LazyVGrid(columns:[GridItem(), GridItem(), GridItem()]){
                            Text("Food Name")
                            Text("Brand")
                            Text("Calories")
            }
            ScrollView{
                LazyVGrid(columns:[GridItem(), GridItem(), GridItem()]){
                                ForEach(foodItems, id: \.self){foodItem in
                                    Text(foodItem.description).foregroundStyle(.secondary).frame(height: 30)
                                    Text(foodItem.brandOwner).foregroundStyle(.secondary)
                                        Text("X").foregroundStyle(.secondary)
                                }
                            }
            }
            
            
        }
        
        
        Spacer()
        
    }
}

var APIkey: String = "XBE7L00LGr70XHL9IbbPfSBorCMSYewbaC5nbgKo"

func buildUrl (searchText: String) -> String {
    let newText  = searchText.replacingOccurrences(of: " ", with: "%20")
    print(newText)
    let endURL : String = "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=\(APIkey)&query=\(newText)&sortBy=dataType.keyword"
    print(endURL)
    return endURL
}

func getFoodData(searchText: String) async -> [Food] {
    var newFoodItems: [Food] = []
    
    guard let newFoodItems2: FoodsResponse = await WebService().downloadData(fromURL: buildUrl(searchText: searchText)) else {
        return newFoodItems
    }
    newFoodItems = newFoodItems2.foods
    return newFoodItems
}

#Preview {
    FoodFinderView()
}
