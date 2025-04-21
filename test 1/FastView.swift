//
//  FastView.swift
//  test 1
//
//  Created by Ty Blair on 3/14/25.
//

import SwiftUI
import SwiftData

struct FastView: View {
    @Query private var data : [FastData]
    @State private var FastHours: Int = 0
    @State private var FastStartDate: Date = Date()
    @Environment(\.modelContext) private var fastContext
    var body: some View {
        Text("")
            .frame(width: 0.0, height: 0.0).onAppear{
                if !data.isEmpty{
                    FastHours = data.first!.fastDuration
                    FastStartDate = data.first!.fastStartTime
                    if Int(hoursElapsed(startDate: Date(), currentDate: Date(timeInterval:Double(FastHours) * 3600, since:FastStartDate))) < 0{
                        fastContext.delete(data.first!)
                        FastHours = 0
                        FastStartDate = Date()
                    }
                }
            }
        VStack(){
            Text("Fasting").font(.largeTitle)
            LazyVGrid(columns: [GridItem(), GridItem()]){
                Text("Fast Hours")
                Text("Daily Eat Hours")
                Picker("Select Fast Hours", selection: $FastHours){
                    ForEach(0...100, id: \.self){ value in
                        Text(value.description)
                    }	
                }
                //use function to check for daily eat hours
                Text(CheckDailyEatHours(Hours: FastHours).description)
                    
            }
            Text("Set Fast Start Time")
            DatePicker("", selection: $FastStartDate, displayedComponents: [.date, .hourAndMinute]).labelsHidden()
            
            Text("Eat: \((Date(timeInterval:Double(FastHours) * 3600, since:FastStartDate).formatted()))").font(.largeTitle).padding(.vertical, 20.0)
            
            Text("Hours Elapsed: \(Int(hoursElapsed(startDate: FastStartDate, currentDate: Date())).description)").font(.largeTitle).padding(.bottom, 20.0)
            
            Text(Int(hoursElapsed(startDate: Date(), currentDate: Date(timeInterval:Double(FastHours) * 3600, since:FastStartDate))).description).font(.largeTitle)
            + Text(" Hours Until You Can Break Fast").font(.largeTitle)
            
            Spacer()
            
            Button(action: {
                if !data.isEmpty{
                    fastContext.delete(data.first!)
                }
                fastContext.insert(FastData(fastStartTime: FastStartDate, fastDuration: FastHours))
            }){
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue)
                    .frame(width: 300, height: 100)
                    .overlay(
                        Text("Save")
                            .font(.title)
                            .foregroundColor(.white)
                    )
            }
            Button(action: {
                if !data.isEmpty{
                    fastContext.delete(data.first!)
                }
                FastHours = 0
                FastStartDate = Date()
            }){
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.red)
                    .frame(width: 300, height: 100)
                    .overlay(
                        Text("Clear")
                            .font(.title)
                            .foregroundColor(.white)
                    )
            }
            
        }
        
        
    }
}

func hoursElapsed(startDate: Date, currentDate: Date) -> TimeInterval{
    var hours: TimeInterval = 0
    
    hours = currentDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
    hours = hours / 3600
    return hours
}

func CheckDailyEatHours(Hours: Int) -> Int {
    var DailyHours: Int = 24
    if Hours >= 24 {
        DailyHours = 0
    } else {
        DailyHours = 24 - Hours
    }
    return DailyHours
}

#Preview {
    FastView().modelContainer(for: FastData.self, inMemory: true)
}
