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

let heartRateServiceCBUUID = CBUUID(string: "0x180D")
let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
let bodySensorLocationCharacteristicCBUUID = CBUUID(string: "2A38")

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
            HStack {
                Button(action: {
                    self.ble.writeValue(message: "a")
                    self.activeAction = "Danger Demo"
                }) {
                    VStack {
                        Image("Danger Demo").renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                    }.padding().foregroundColor(.white).background(Color.red).cornerRadius(40)
                }.accentColor(self.activeAction == "Danger Demo" ? Color.red : Color.secondary)
            }.padding(.bottom)
            Text("Copyright © 2020 David Ionita. All rights reserved.").fontWeight(.light).font(.system(size: 10))
        }
        /*
        List {
            Section(header: Text("Action Panel"), footer: Text("Copyright © 2020 David Ionita. All rights reserved.")) {
                    ForEach(actions) { ac in
                    /// START HERE
                        Button(action: {
                            self.activeAction = ac.name
                            self.activeColor = ac.color
                            
                            // Make BT call with character
                                    // If Danger Demo, send b (red) and g (white)
                            
                            print(ac.letter)
                            /// GET RID OF
                            print(self.ble.theCharacteristic!.uuid)
                            self.ble.writeValue(message: String(ac.letter))

                        }) {
                            HStack { Image(ac.name).renderingMode(.original).resizable().scaledToFit().frame(width: 40, height: 40)
                                
                                Text(ac.name).foregroundColor(ac.color)
                            }
                        }
                    /// END HERE
                    }
                }.onAppear { self.ble.startScanning() }

        
        }*/
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(ble: BLEManager())
    }
}
