//
//  ContentView.swift
//  UnitConverter
//
//  Created by Wassim Mansouri on 26/12/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedType: String = "Temperature"
    @State private var selectedSource: String = "Celsius"
    @State private var sourceUnitAmount: Int = 1
    @FocusState private var sourceAmountIsFocused: Bool
    @State private var selectedTarget: String = "Fahrenheit"
    @State private var targetUnitAmount: Int = 1
    
    let types = ["Temperature", "Length", "Time", "Volume"]
    let tempUnits = ["Celsius", "Fahrenheit", "Kelvin"]
    
    let units:[String: [String]]  = [
        "Temperature": ["Celsius", "Fahrenheit", "Kelvin"],
        "Length": ["Meters", "Kilometers", "Feet", "Yards", "Miles"],
        "Time": ["Seconds", "Minutes", "Hours", "Days"],
        "Volume": ["Milliliters", "Liters", "Cups", "Pints", "Gallons"]
    ]
        
    func getUnitList(_ key: String) -> [String] {
        return units[key] ?? tempUnits
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Types", selection: $selectedType) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Select a unit type")
                }
                
                Section {
                    Picker("Types", selection: $selectedSource) {
                        ForEach(getUnitList(selectedType), id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Select the source unit")
                }
                
                Section {
                    TextField("Source unit amount", value: $sourceUnitAmount, format: .number)
                        .keyboardType(.numberPad)
                        .focused($sourceAmountIsFocused)
                } header: {
                    Text("Enter source unit amount")
                }
                
                Section {
                    Picker("Types", selection: $selectedTarget) {
                        ForEach(getUnitList(selectedType), id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Select the target unit")
                }
                
                Section {
                    Text("\(sourceUnitAmount) \(selectedSource) is \(targetUnitAmount) \(selectedTarget)")
                } header: {
                    Text("Reslut")
                }
            }
            .navigationTitle("Unit Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        sourceAmountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
