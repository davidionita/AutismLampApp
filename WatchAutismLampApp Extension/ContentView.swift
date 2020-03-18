//
//  ContentView.swift
//  WatchAutismLampApp Extension
//
//  Created by David Ionita on 3/12/20.
//  Copyright © 2020 David Ionita. All rights reserved.
//

import SwiftUI
import Combine
import CoreBluetooth
import HealthKit

struct ActionData: Identifiable {
    var id = UUID()
    var name: String
    var color: Color
    var letter: Character
}

struct ContentView: View {
    
    var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    
    @State var value = 0
    
    let actions = [
        ActionData(name: "Bathroom", color: Color.purple, letter: "e"),
        ActionData(name: "Hungry", color: Color.blue,letter: "f"),
        ActionData(name: "Hurt", color: Color.pink, letter: "a"),
        ActionData(name: "Mom", color: Color.green, letter: "d"),
        ActionData(name: "Play", color: Color.red, letter: "a"),
        ActionData(name: "Sleep", color: Color.blue, letter: "f"),
        ActionData(name: "Teacher", color: Color.green, letter: "h"),
        ActionData(name: "Thirsty", color: Color.primary, letter: "g"),
        ActionData(name: "Danger Demo", color: Color.red, letter: "a")  // Alternative red and white
    ]
    
    @State var activeAction = "No Action"
    @State var activeColor = Color.primary
    
    @ObservedObject var ble: BLEManager
    
    @State var btPaired = true
    var body: some View {
        ScrollView(.vertical) {
            Text("Lamp Dashboard").fontWeight(.semibold)
            HStack {
                Text(self.btPaired ? "Paired" : "Unpaired").foregroundColor(btPaired ? Color.green : Color.red)

                Spacer()
                
                Button(action: {
                    if (self.btPaired) {
                        print("Try to disconnect")
                        self.ble.manager.cancelPeripheralConnection(self.ble.getConnectedPeripheral())
                    } else {
                        print("Try to reconnect")
                        self.ble.manager.connect(self.ble.getConnectedPeripheral())
                    }
                    
                    print(self.btPaired ? "Disconnected!" : "Reconnected!")
                    self.btPaired = !self.btPaired
                }) {
                    HStack {
                        Text(self.btPaired ? "Disconnect" : "Reconnect")
                    }
                }
            }
            
            HStack {
                Spacer()
                Button(action: {
                    self.ble.writeValue(message: "a")
                    self.activeAction = "Danger Demo"
                }) {
                    VStack {
                        Image("Danger Demo").renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                    }.padding().foregroundColor(.white).background(Color.red).cornerRadius(40)
                }.accentColor(self.activeAction == "Danger Demo" ? Color.red : Color.secondary)
                Spacer()
                Button(action: {
                    
                }) {
                    VStack {
                        Text("\(value)").frame(width: 40, height: 40)
                    }.padding().foregroundColor(.white).background(value <= 110 ? Color.green : Color.red).cornerRadius(10)
                }.disabled(true)
                Spacer()
            }.padding(.bottom)
            
            HStack {
                Spacer()
                Button(action: {
                    self.ble.writeValue(message: "e")
                    self.activeAction = "Bathroom"
                }) {
                    VStack {
                        Image("Bathroom").renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                    }.padding().foregroundColor(.white).background(Color.purple).cornerRadius(40)
                }.accentColor(self.activeAction == "Bathroom" ? Color.purple : Color.secondary)
                Spacer()
                Button(action: {
                    self.ble.writeValue(message: "f")
                    self.activeAction = "Hungry"
                }) {
                    VStack {
                        Image("Hungry").renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                    }.padding().foregroundColor(.white).background(Color.blue).cornerRadius(40)
                }.accentColor(self.activeAction == "Hungry" ? Color.blue : Color.secondary)
                Spacer()
            }.padding(.bottom)
            
            HStack {
                Spacer()
                Button(action: {
                    self.ble.writeValue(message: "a")
                    self.activeAction = "Hurt"
                }) {
                    VStack {
                        Image("Hurt").renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                    }.padding().foregroundColor(.white).background(Color.pink).cornerRadius(40)
                }.accentColor(self.activeAction == "Hurt" ? Color.pink : Color.secondary)
                Spacer()
                Button(action: {
                    self.ble.writeValue(message: "d")
                    self.activeAction = "Mom"
                }) {
                    VStack {
                        Image("Mom").renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                    }.padding().foregroundColor(.white).background(Color.green).cornerRadius(40)
                }.accentColor(self.activeAction == "Mom" ? Color.green : Color.secondary)
                Spacer()
            }.padding(.bottom)
            
            HStack {
                Spacer()
                Button(action: {
                    self.ble.writeValue(message: "a")
                    self.activeAction = "Play"
                }) {
                    VStack {
                        Image("Play").renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                    }.padding().foregroundColor(.white).background(Color.red).cornerRadius(40)
                }.accentColor(self.activeAction == "Play" ? Color.red : Color.secondary)
                Spacer()
                Button(action: {
                    self.ble.writeValue(message: "f")
                    self.activeAction = "Sleep"
                }) {
                    VStack {
                        Image("Sleep").renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                    }.padding().foregroundColor(.white).background(Color.blue).cornerRadius(40)
                }.accentColor(self.activeAction == "Sleep" ? Color.blue : Color.secondary)
                Spacer()
            }.padding(.bottom)
            
            HStack {
                Spacer()
                Button(action: {
                    self.ble.writeValue(message: "h")
                    self.activeAction = "Teacher"
                }) {
                    VStack {
                        Image("Teacher").renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                    }.padding().foregroundColor(.white).background(Color.green).cornerRadius(40)
                }.accentColor(self.activeAction == "Teacher" ? Color.green : Color.secondary)
                Spacer()
                Button(action: {
                    self.ble.writeValue(message: "g")
                    self.activeAction = "Thirsty"
                }) {
                    VStack {
                        Image("Thirsty").renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                    }.padding().foregroundColor(.white).background(Color.primary).cornerRadius(40)
                }.accentColor(self.activeAction == "Thirsty" ? Color.primary : Color.secondary)
                Spacer()
            }.padding(.bottom)

            Text("Copyright © 2020 David Ionita. All rights reserved.").fontWeight(.light).font(.system(size: 10))
        }.onAppear{ self.ble.startScanning()}.onAppear(perform: start)
        
    }
    
    func start() {
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        // 1
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        // 2
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            // 3
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
            
        self.process(samples, type: quantityTypeIdentifier)

        }
        
        // 4
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        // 5
        
        healthStore.execute(query)
    }
    
    func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            
            self.value = Int(lastHeartRate)
            if (self.value > 110) {
                self.ble.writeValue(message: String("a"))
            }
        }
        
        if (self.value > 110) {
            self.ble.writeValue(message: String("a"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(ble: BLEManager())
    }
}
