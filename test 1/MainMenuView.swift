//
//  MainMenuView.swift
//  test 1
//
//  Created by Ty Blair on 3/13/25.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack{
            VStack {
                Text("Title").font(.largeTitle)
                Spacer()
                
                ZStack{
                    Rectangle().fill(Color.gray).frame(width: 300, height: 200)
                    Text("placeholder \nweight chart").font(.largeTitle)
                }
                
                
                ScrollView {
                    ZStack{
                        Rectangle().fill(Color.gray).frame(width: 300, height: 150)
                        Text("placeholder fast schedule").font(.largeTitle)
                    }
                        
                    MoveButtonView(buttonttext:"Record Weight", buttondestination: WeightView())
                    MoveButtonView(buttonttext:"Record Meal", buttondestination: MealView())
                    MoveButtonView(buttonttext:"Set Diet Goals", buttondestination: DietView())
                    MoveButtonView(buttonttext:"Set Fasting Schedule", buttondestination: FastView())
                }
            }
            .padding()    }
    }
}
#Preview {
    MainMenuView()
        .modelContainer(for: Weight.self, inMemory: true)
}
