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

struct weightChart: View {
    @Query private var weights: [Weight]
    var body: some View {
        Chart(weights.sorted(by:{$0.datetaken < $1.datetaken})){
            LineMark(
                x: .value("Date", $0.datetaken),
                y: .value("Weight", $0.weightvalue)
            ).foregroundStyle(.green)
        }
    }
}

#Preview {
    MainMenuView()
        .modelContainer(for: Weight.self, inMemory: true)
}
