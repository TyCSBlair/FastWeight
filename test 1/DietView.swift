//
//  DietView.swift
//  test 1
//
//  Created by Ty Blair on 3/14/25.
//

import SwiftUI
import SwiftData

struct DietView: View {
    @State private var ProteinUpperBound: Double = 100
    @State private var CarbohydrateUpperBound: Double = 100
    @State private var FatUpperBound: Double = 100
    @State private var ProteinValue: Double = 0
    @State private var CarbohydrateValue: Double = 0
    @State private var FatValue: Double = 0
    @State private var Calories: String = ""
    @Query private var diet: [Macros]
    @Environment(\.modelContext) private var context3
    @State private var showCalPopUp: Bool = false
    var body: some View {
        Text("").frame(width: 0, height: 0).onAppear {
            if !diet.isEmpty {
                ProteinValue = diet[0].protein
                CarbohydrateValue = diet[0].carbohydrates
                FatValue = diet[0].fat
                Calories = String(diet[0].calories)
                ProteinUpperBound = 100 - (FatValue + CarbohydrateValue)
                FatUpperBound = 100 - (ProteinValue + CarbohydrateValue)
                CarbohydrateUpperBound = 100 - (FatValue + ProteinValue)
            }
        }
        Text("diet test").font(.largeTitle)
        Spacer()
        TextField("", text: $Calories, prompt: Text("Input Calorie Goal (kCal)")).keyboardType(.numberPad).padding([.leading, .bottom, .trailing]).labelsHidden().frame(width: 218, height: 60.0).background(RoundedRectangle(cornerRadius: 10).padding(.bottom).foregroundColor(Color.gray.opacity(0.2)))
        Text("Protein Value")+Text(" (\(String(format: "%.01f",ProteinUpperBound))% Max Value)")
        Slider(value: $ProteinValue, in: 0...100, onEditingChanged: { i in
            ProteinUpperBound = 100 - (FatValue + CarbohydrateValue)
            FatUpperBound = 100 - (ProteinValue + CarbohydrateValue)
            CarbohydrateUpperBound = 100 - (FatValue + ProteinValue)
            if ProteinValue > ProteinUpperBound {
                ProteinValue = ProteinUpperBound
                FatUpperBound = 100 - (ProteinValue + CarbohydrateValue)
                CarbohydrateUpperBound = 100 - (FatValue + ProteinValue)
            }
        })
        .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
        Text("Carb Value")+Text(" (\(String(format: "%.01f",CarbohydrateUpperBound))% Max Value)")
        Slider(value: $CarbohydrateValue, in: 0...100, onEditingChanged: { i in
            CarbohydrateUpperBound = 100 - (FatValue + ProteinValue)
            ProteinUpperBound = 100 - (FatValue + CarbohydrateValue)
            FatUpperBound = 100 - (ProteinValue + CarbohydrateValue)
            if CarbohydrateValue > CarbohydrateUpperBound {
                CarbohydrateValue = CarbohydrateUpperBound
                ProteinUpperBound = 100 - (FatValue + CarbohydrateValue)
                FatUpperBound = 100 - (ProteinValue + CarbohydrateValue)
            }
        })
            .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
        Text("Fat Value")+Text(" (\(String(format: "%.01f",FatUpperBound))% Max Value)")
        Slider(value: $FatValue, in: 0...100, onEditingChanged: { i in
            FatUpperBound = 100 - (ProteinValue + CarbohydrateValue)
            CarbohydrateUpperBound = 100 - (FatValue + ProteinValue)
            ProteinUpperBound = 100 - (FatValue + CarbohydrateValue)
            if FatValue > FatUpperBound {
                FatValue = FatUpperBound
                CarbohydrateUpperBound = 100 - (FatValue + ProteinValue)
                ProteinUpperBound = 100 - (FatValue + CarbohydrateValue)
            }
        })
            .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
        Button(action:{
            let total: Double = ProteinValue+CarbohydrateValue+FatValue
            
            if total <= 99{
                let proteinRatio: Double = ProteinValue/total
                let carbohydrateRatio: Double = CarbohydrateValue/total
                let fatRatio: Double = FatValue/total
                ProteinValue = proteinRatio*100
                CarbohydrateValue = carbohydrateRatio*100
                FatValue = fatRatio*100
                ProteinUpperBound = 100 - (FatValue + CarbohydrateValue)
                FatUpperBound = 100 - (ProteinValue + CarbohydrateValue)
                CarbohydrateUpperBound = 100 - (FatValue + ProteinValue)
            }
            if !diet.isEmpty{
                if Float(Calories) != nil{
                    context3.delete(diet.first!)
                    context3.insert(Macros(protein: ProteinValue, carbohydrates: CarbohydrateValue, fat: FatValue, calories: Float(Calories)!))
                } else {showCalPopUp = true
                    }
            } else {
                if Float(Calories) != nil{
                    context3.insert(Macros(protein: ProteinValue, carbohydrates: CarbohydrateValue, fat: FatValue, calories: Float(Calories)!))} else {showCalPopUp = true

                    }
            }
            
            
        }){
            RoundedRectangle(cornerRadius: 20).frame(width:300, height:100).overlay(Text("Save").font(.largeTitle).foregroundStyle(.white))
        }.popover(isPresented: $showCalPopUp){Text("Please Input Calorie Goal (as a numeric value)").frame(width:200, height: 100).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).presentationCompactAdaptation(.popover)}
        Spacer()
        Spacer()
    }
}

#Preview {
    DietView().modelContainer(for:Macros.self, inMemory: true)
}
