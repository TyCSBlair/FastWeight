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
    @Query private var weights: [Weight]
    @Environment(\.modelContext) private var context
    @State private var selectedDate: Date = Date()
    var body: some View {
        VStack {
            Text("Weight").font(.largeTitle)
            DatePicker("Choose Date:", selection: $selectedDate, displayedComponents: .date).labelsHidden()
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
                    }
                    Text("LBs")
                        .multilineTextAlignment(.leading)
                        .padding(.leading, -2.0)
                }
                    
            }
            Spacer()
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()]){
                    Text("Weight Recorded").font(.headline)
                    Text("Date Recorded").font(.headline)
                    ForEach(0..<weights.count, id: \.self){ id in
                        Menu{
                            Button(action: {
                                context.delete(weights[id])
                               
                            }){
                                Text("0 (delete entry)")
                            }
                            ForEach(1...300, id: \.self) { value in
                                Button(action: {
                                    context.delete(weights[id])
                                    context.insert(Weight(id:id, weightvalue: value, datetaken: weights[id].datetaken))
                                    
                                }){
                                    Text(value.description)
                                }
                            }
                        } label: {Text(weights[id].weightvalue.description)}
                        Text(weights[id].datetaken.formatted(date: .numeric, time: .omitted))
                    }
                }
            }
            
            }
        }
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
