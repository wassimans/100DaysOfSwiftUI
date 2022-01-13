//
//  ContentView.swift
//  BetterRest
//
//  Created by Wassim Mansouri on 09/01/2022.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 5
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("When do you want to wake up?") {
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake") {
                    
                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                    // Alternative UI for coffee intake selection
//                    Picker(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
//                        ForEach(1...20, id: \.self) {
//                            Text(String($0))
//                        }
//                    }
                }
                
                Section("Your ideal bedtime is..") {
                    Text(calculateBedTime())
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            
            }
            .navigationTitle("BetterRest")
            
        }
    }
    
    func calculateBedTime() -> String {
        var sleepTime = Date.now
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            // Calculate number of hours in seconds
            let hour = (components.hour ?? 0) * 60 * 60
            // Calculate number of minutes in seconds
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            sleepTime = wakeUp - prediction.actualSleep
        } catch {
            print("Sorry, there was a problem calculating your bedtime.")
        }
        return sleepTime.formatted(date: .omitted, time: .shortened)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
