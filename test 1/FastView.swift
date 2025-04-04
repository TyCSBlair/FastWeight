//
//  FastView.swift
//  test 1
//
//  Created by Ty Blair on 3/14/25.
//

import SwiftUI
import SwiftData

struct FastView: View {
    @State private var FastHours: Int = 0
    @State private var FastStartDate: Date = Date()
    @Environment(\.modelContext) private var fastContext
    var body: some View {
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
    FastView()
}
