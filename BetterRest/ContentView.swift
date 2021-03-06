//
//  ContentView.swift
//  BetterRest
//
//  Created by Joel Groomer on 6/8/21.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
        
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Form {
                    Section(header: Text("When do you want to wake up?")) {
                        DatePicker("Please enter a time",
                                   selection: $wakeUp,
                                   displayedComponents: .hourAndMinute)
                    }
                    
                    Section(header: Text("Desired amount of sleep")) {
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g") hours")
                        }
                    }
                    
                    Section(header: Text("Daily coffee intake")) {
                        Picker("Number of cups", selection: $coffeeAmount) {
                            ForEach(1...20, id: \.self) { cups in
                                if cups == 1 {
                                    Text("1 cup")
                                } else {
                                    Text("\(cups) cups")
                                }
                            }
                        }
                    }
                }
                
                Text("Optimal bedtime:")
                    .font(.title)
                Text("\(calculateBedtime())")
                    .font(.largeTitle)
                Spacer()
            }
            
            .navigationBarTitle("BetterRest")
        }
    }
    
    func calculateBedtime() -> String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
        } catch {
            return "ERR"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
