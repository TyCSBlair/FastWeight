//
//  WeightView.swift
//  test 1
//
//  Created by Ty Blair on 3/14/25.
//

import SwiftUI
import SwiftData

struct WeightView: View {
    @State private var selectedWeight: Int = 150
//    @State private var selectedWeightDecimal: Int = 0
    @Query private var weights: [Weight]
    @Environment(\.modelContext) private var context
    @State private var selectedDate: Date = Date()
    var body: some View {
        VStack {
            Text("Weight").font(.largeTitle)
            DatePicker("Choose Date:", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute]).labelsHidden()
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color.teal)
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
            Divider()
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()]){
                    @State var sortedweights: [Weight] = weights.sorted(by: {$0.datetaken > $1.datetaken})
                    Text("Weight Recorded").font(.headline)
                    Text("Date Recorded").font(.headline)
                    ForEach(0..<sortedweights.count, id: \.self){ id in
                        Menu{
                            Button(action: {
                                context.delete(weights[findIndex(ID: sortedweights[id].id, weights: weights)])
                               
                            }){
                                Text("0 (delete entry)")
                            }
                            ForEach(1...300, id: \.self) { value in
                                Button(action: {
                                    context.delete(weights[findIndex(ID: sortedweights[id].id, weights: weights)])
                                    context.insert(Weight(id:sortedweights[id].id, weightvalue: value, datetaken: weights[sortedweights[id].id].datetaken))
                                    
                                }){
                                    Text(value.description)
                                }
                            }
                        } label: {Text(sortedweights[id].weightvalue.description)}
                        Text(sortedweights[id].datetaken.formatted(date: .numeric,time: .shortened))
                    }
                }
            }
            
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
