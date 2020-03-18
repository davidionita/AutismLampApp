//
//  ContentView.swift
//  AutismLampApp
//
//  Created by David Ionita on 3/8/20.
//  Copyright © 2020 David Ionita. All rights reserved.
//

import SwiftUI
import Combine
import CoreBluetooth

struct ActionData: Identifiable {
    var id = UUID()
    var name: String
    var color: Color
    var letter: Character
}

struct ContentView: View {

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
        NavigationView {
            
            List {
                HStack {
                    Text(self.btPaired ? "Paired" : "NOT Paired").foregroundColor(btPaired ? Color.green : Color.red)

                    Spacer()
                    
                    Button(action: {
                        if (self.btPaired) {
                            self.ble.manager.cancelPeripheralConnection(self.ble.getConnectedPeripheral())
                        } else {
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
                    if (activeAction != "No Action") {
                        Image(activeAction).renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                    }
                    
                    Text(activeAction).foregroundColor(activeColor)
                }
                
                Section(header: Text("Action Panel"), footer: Text("Copyright © 2020 David Ionita. All rights reserved.")) {
                    ForEach(actions) { ac in
                    
                        Button(action: {
                            self.activeAction = ac.name
                            self.activeColor = ac.color
                            
                            print(ac.letter)
                            
                            print(self.ble.theCharacteristic!.uuid)
                            self.ble.writeValue(message: String(ac.letter))

                        }) {
                            HStack { Image(ac.name).renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                                
                                Text(ac.name).foregroundColor(ac.color)
                            }
                        }
                    }
                }.onAppear {
                    self.ble.startScanning()
                }

            }.listStyle(GroupedListStyle()).navigationBarTitle("Lamp Dashboard")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(ble: BLEManager())
    }
}
