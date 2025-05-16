//
//  WeightView.swift
//  test 1
//
//  Created by Ty Blair on 3/14/25.
//

import SwiftUI
import SwiftData
import Charts

struct WeightView: View {
    @State private var selectedWeight: Int = 150
//    @State private var selectedWeightDecimal: Int = 0
    @Query private var weights: [Weight]
    @Environment(\.modelContext) private var context
    @State private var selectedDate: Date = Date()
    @State private var chosenDate: Bool = false
    var body: some View {
        @State var sortedweights: [Weight] = weights.sorted(by: {$0.datetaken > $1.datetaken})
        VStack {
            Text("Weight").font(.largeTitle)
            DatePicker("Choose Date:", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute]).labelsHidden().onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)){ _ in
                selectedDate = Date()
            }
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 5).fill(Color.blue)
                        .frame(width: 200, height: 80)
                    Text("Add Weight").font(.title).foregroundColor(Color.white)
                }.onTapGesture{
                    context.insert(Weight(id:findNewID(weights: weights), weightvalue: selectedWeight, datetaken: selectedDate))
                    
                }
                
                HStack{
                    Picker("Select Weight", selection: $selectedWeight) {
                        ForEach(0...300, id: \.self) { value in
                            Text(value.description)
                        }
                    }.padding(.trailing, -12.0)
//                    Text(".")
//                    Picker("Select Weight", selection: $selectedWeightDecimal) {
//                        ForEach(0...9, id: \.self) { value in
//                            Text(value.description)
//                        }
//                    }.padding(.horizontal, -12.0)
                        
                    
                    Text("LBs")
                        .multilineTextAlignment(.leading)
                        .padding(.leading, -2.0)
                }
                    
            }
            Spacer()
            
            LazyVGrid(columns: [GridItem(), GridItem()]){
                Text("Weight Recorded").font(.headline)
                Text("Date Recorded").font(.headline)
            }
            Divider()
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()]){


                    ForEach(sortedweights){ weight in
                        HStack{
                            Button("", systemImage:"trash.fill", action:{
                                context.delete(weights[findIndex(ID:weight.id, weights: weights)])
                            }).foregroundStyle(.red)
                            modPicker(value:weight.weightvalue, weight: weight)
                        }

//                        Menu{
//                            Button(action: {
//                                context.delete(weights[findIndex(ID: sortedweights[id].id, weights: weights)])
//                               
//                            }){
//                                Text("0 (delete entry)")
//                            }
//                            ForEach(1...300, id: \.self) { value in
//                                Button(action: {
//                                    context.delete(weights[findIndex(ID: sortedweights[id].id, weights: weights)])
//                                    context.insert(Weight(id:sortedweights[id].id, weightvalue: value, datetaken: weights[sortedweights[id].id].datetaken))
//                                    
//                                }){
//                                    Text(value.description)
//                                }
//                            }
//                        } label: {Text(sortedweights[id].weightvalue.description)}
                        Text(weight.datetaken.formatted(date: .numeric,time: .shortened))
                    }
                }
            }
            Divider()
            
            if !sortedweights.isEmpty {
                weightChart().frame(height:150)
                Text("Weight Chart").font(.caption)
            }

            
            }
        }
    }

struct modPicker: View {
    @State var value: Int
    @Query private var weights: [Weight]
    let weight: Weight
    @Environment(\.modelContext) private var context
    
    var body: some View {
        let id: Int = weight.id
        let date: Date = weight.datetaken
        Picker("", selection: $value) {
            ForEach(0..<300) { i in
                Text("\(i) lbs")
            }
        }.onChange(of: value){
            context.delete(weights[findIndex(ID: id, weights: weights)])
            context.insert(Weight(id:id, weightvalue: value, datetaken: date))
        }
    }
}

func findIndex(ID: Int, weights: [Weight]) -> Int {
    var index: Int = 0
    for i in weights.indices{
        if weights[i].id == ID{
            index = i
        }
    }
    return index
}

func findNewID(weights: [Weight]) -> Int {
    var newId: Int = 0
    for i in weights{
        if i.id >= newId{
            newId = i.id + 1
        }
    }
    print(newId.description)
    return newId
}


#Preview {
    WeightView()
        .modelContainer(for: Weight.self, inMemory: true)
}
