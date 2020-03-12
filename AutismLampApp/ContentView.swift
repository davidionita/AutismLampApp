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

    // @State var btStatus = "Paired"
    //  if (self.aManager.aPeripheral != nil)
    
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
                    }
                }.onAppear { self.ble.startScanning() }

            }.listStyle(GroupedListStyle()).navigationBarTitle("Lamp Dashboard")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(ble: BLEManager())
    }
}


/*
class ARDManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    var aPeripheral: CBPeripheral!
    var centralManager: CBCentralManager!
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        @unknown default:
            print("fatal")
            fatalError()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print(peripheral)
        //if (peripheral.name == "SH-HC-08") {
        if (peripheral.name == "David’s MacBook Pro") {
            aPeripheral = peripheral
            aPeripheral.delegate = peripheral.delegate.self
            centralManager.stopScan()
            centralManager.connect(aPeripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        aPeripheral.discoverServices(nil)
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
    }
    
}


extension ARDManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        for characteristic in characteristics {
            print(characteristic.uuid)
                peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {
                return
        }
        
       // receivedData.send(data)
    }

}

extension CBPeripheral: Identifiable {
    public var id: UUID {
        return identifier
    }
}
*/
