//
//  GlucoseView.swift
//  test 1
//
//  Created by Ty Blair on 4/22/25.
//

import SwiftUI
import SwiftData
import Charts

struct GlucoseView: View {
    @Query private var glucoseData: [GlucoseData]
    
    @State private var glucoseSelection: Int = 100
    @State private var selectedDate: Date = Date()
    @Environment(\.modelContext) private var context
    var body: some View {
        @State var sortedGlucoseData: [GlucoseData] = glucoseData.sorted(by: {$0.date > $1.date})
        Text("Fasting Glucose").font(.title)
        DatePicker("", selection: $selectedDate).labelsHidden()
        Spacer()
        HStack{
            Button(action:{
                context.insert(GlucoseData(gId: findNewGlucoseID(data: glucoseData), date: selectedDate, glucose: Double(glucoseSelection)))
            }){
                RoundedRectangle(cornerRadius: 5)
                    .frame(width:125, height: 75).overlay(content: {
                        Text("Add").font(.title).foregroundStyle(.white)
                    })
            }.padding()
            
            Picker("", selection: $glucoseSelection){
                ForEach (40...250, id: \.self){ i in
                    Text(i.description)
                }
            }
            Text("mg/dL")
        }
        Spacer()
        LazyVGrid(columns:[GridItem(), GridItem()]){
            Text("Glucose")
            Text("Date")
        }
        Divider()
            .padding(.horizontal)
        ScrollView{
            LazyVGrid(columns:[GridItem(), GridItem()]){
                ForEach(sortedGlucoseData) { data in
                    HStack{
                        Button("", systemImage: "trash.fill", action: {
                            context.delete(glucoseData.first(where: {$0.gId == data.gId})!)
                        }).foregroundStyle(.red)
                        Text(String(data.glucose))
                    }.padding()
                    
                    Text(data.date.formatted(date: .numeric,time: .shortened))
                }
            }
        }
        
        if !sortedGlucoseData.isEmpty {
            Chart(sortedGlucoseData){
                LineMark(
                    x: .value("Date", $0.date),
                    y: .value("Glucose", $0.glucose)
                ).foregroundStyle(.green)
            }.frame(height:150)
            Text("Glucose Chart").font(.caption)
        }

    }
}

//struct weightChart: View {
//    @Query private var glucoseData: [Weight]
//    var body: some View {
//        
//        Chart(weights.sorted(by:{$0.datetaken < $1.datetaken})){
//            LineMark(
//                x: .value("Date", $0.datetaken),
//                y: .value("Weight", $0.weightvalue)
//            ).foregroundStyle(.green)
//        }.chartYScale(domain: [findMinWeight(weights: weights) - 10, findMaxWeight(weights: weights) + 10])
//    }
//}

func findNewGlucoseID(data: [GlucoseData]) -> Int {
    var newID: Int = 0
    for i in data {
        if i.gId >= newID {
            newID = i.gId + 1
        }
    }
    return newID
}

#Preview {
    GlucoseView().modelContainer(for: GlucoseData.self, inMemory: true)
}
