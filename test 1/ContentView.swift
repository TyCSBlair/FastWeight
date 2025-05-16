//
//  ContentView.swift
//  test 1
//
//  Created by Ty Blair on 3/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MainMenuView().modelContainer(for: [Weight.self, StoredFood.self, Macros.self, FastData.self, BloodPressureData.self, GlucoseData.self])
    }
}

struct MoveButtonView<Content: View>: View {
    let buttonttext	: String
    let buttondestination: Content
    var body: some View {
        NavigationLink(destination: buttondestination){
            ZStack{
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.blue)
                    .frame(width: 300, height: 60)
                Text(buttonttext)
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(Color.white)
                    .padding()
                }
            }
        }
}

struct ButtonView: View {
    var buttonttext : String
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.teal)
                .frame(width: 130, height: 60)
            Text(buttonttext)
                .font(.title)
                .foregroundColor(.white)
                .padding()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Weight.self, StoredFood.self, Macros.self, FastData.self], inMemory: true)
}
