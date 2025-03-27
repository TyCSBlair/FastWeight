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
        }.chartYScale(domain: [findMinWeight(weights: weights) - 10, findMaxWeight(weights: weights) + 10])
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
        .modelContainer(for: Weight.self, inMemory: true)
}
