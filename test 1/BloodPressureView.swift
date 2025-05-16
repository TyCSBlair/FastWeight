//
//  BloodPressureView.swift
//  test 1
//
//  Created by Ty Blair on 4/23/25.
//

import SwiftUI
import SwiftData

struct BloodPressureView: View {
    @Query private var bloodPressureData: [BloodPressureData]
    @State private var selectedDate: Date = Date()
    @State private var selectedSystolic: Int = 100
    @State private var selectedDiastolic: Int = 100
    @Environment(\.modelContext) private var context
    var body: some View {
        ScrollViewReader{ reader in
        VStack{
            Text("Blood Pressure").font(.title)
            DatePicker("Choose Date:", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute]).labelsHidden().onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)){ _ in
                selectedDate = Date()
            }
            HStack{
                Button(action:{
                    context.insert(BloodPressureData(bpId: findNewBpID(data: bloodPressureData), systolic: selectedSystolic, diastolic: selectedDiastolic, date: selectedDate))
                    reader.scrollTo(0)
                }){
                    RoundedRectangle(cornerRadius: 5).frame(width: 125, height: 75).foregroundStyle(Color.blue).overlay(Text("Add").foregroundStyle(.white).font(.title))
                }
                VStack{
                    Text("Systolic")
                    Picker("Systolic", selection: $selectedSystolic){
                        ForEach(1...300, id:\.self){ i in
                            Text(i.description)
                        }
                    }
                }.padding()
                VStack{
                    Text("Diastolic")
                    Picker("Diastolic", selection:$selectedDiastolic){
                                        ForEach(1...300, id:\.self){ i in
                                            Text(i.description)
                                        }
                                    }
                }.padding()
                
            }
            LazyVGrid(columns:[GridItem(), GridItem(), GridItem()]){
                Text("Systolic")
                Text("Diastolic")
                Text("Date")
            }
            Divider()

                ScrollView{
                    @Namespace var topId
                    @State var sortedBPData: [BloodPressureData] = bloodPressureData.sorted(by: {$0.date > $1.date})
                    Text("").id(topId)
                        LazyVGrid(columns:[GridItem(), GridItem(), GridItem()]){
                            ForEach(sortedBPData) { data in
                                HStack{
                                    Button("",systemImage:"trash.fill", action:{
                                        context.delete(bloodPressureData[findBpIndex(data: bloodPressureData, id: data.bpId)])
                                    }).foregroundStyle(.red).labelsHidden()
                                    elementPicker(value: data.systolic, data: data, SorD: 1)
                                }
                                elementPicker(value: data.diastolic, data: data, SorD: 2)
                                Text("\(data.date.formatted(date: .numeric,time: .shortened))").onAppear{reader.scrollTo(topId, anchor: .top)}
                            }.onChange(of:sortedBPData){
                                print("a")
                                reader.scrollTo(topId, anchor: .top)
                                reader.scrollTo(topId, anchor: .top)
                            }
                        }
                    Button(action:{reader.scrollTo(topId, anchor: .top)}){Text("Debug")}
                }
            }

            Spacer()
        }

    }
}

struct elementPicker: View{
    @State var value: Int
    @Query private var bloodPressureData: [BloodPressureData]
    let data: BloodPressureData
    let SorD: Int

    @Environment(\.modelContext) private var context
    var body: some View{
        let bpId: Int = data.bpId
        var bpSystolic: Int = data.systolic
        var bpDiastolic: Int = data.diastolic
        let bpDate: Date = data.date
        Picker("", selection: $value){
            ForEach(1...300, id: \.self){ i in
                Text(i.description)
            }
        }.onChange(of: value){
            if SorD == 1 {
                bpSystolic = value
            } else if SorD == 2 {
                bpDiastolic = value
            }
            context.delete(bloodPressureData[findBpIndex(data:bloodPressureData, id: data.bpId)])
            context.insert(BloodPressureData(bpId:bpId,systolic: bpSystolic, diastolic: bpDiastolic, date: bpDate))
        }
    }
}

func findNewBpID(data: [BloodPressureData]) -> Int {
    var newID: Int = 0
    for i in data {
        if newID <= i.bpId {
            newID = i.bpId + 1
        }
    }
    return newID
}

func findBpIndex(data: [BloodPressureData], id: Int) -> Int {
    var index: Int = 0
    for i in data.indices {
        if data[i].bpId == id {
            index = i
        }
    }
    
    return index
}

#Preview {
    BloodPressureView().modelContainer(for: BloodPressureData.self, inMemory: true)
}
