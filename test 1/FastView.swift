//
//  FastView.swift
//  test 1
//
//  Created by Ty Blair on 3/14/25.
//

import SwiftUI

struct FastView: View {
    @State private var FastHours: Int = 0
    @State private var FastStartDate: Date = Date()
    @State private var FastStartTime: Date = Date()
    var body: some View {
        VStack(){
            Text("Title").font(.largeTitle)
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
                Text("Start Date")
                Text("Start Time")
                //put day picker here
                DatePicker("", selection: $FastStartDate, displayedComponents: .date).labelsHidden()
                //put time picker here
                DatePicker("", selection: $FastStartTime, displayedComponents: .hourAndMinute).labelsHidden()
                
                ButtonView(buttonttext: "Clear")
                ButtonView(buttonttext: "Save")
            }
            Text("XX").font(.largeTitle)
            + Text(" Hours Until You Can Break Fast").font(.largeTitle)
                
            Text("Eat:")
                .font(.largeTitle)
            + Text("").font(.largeTitle)
            
        }
    }
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
