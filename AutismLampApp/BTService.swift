//
//  BTService.swift
//  AutismLampApp
//
//  Created by David Ionita on 3/8/20.
//  Copyright © 2020 David Ionita. All rights reserved.
//

import Foundation
import Combine
import CoreBluetooth

class BLEManager: NSObject, ObservableObject {
    lazy var manager: CBCentralManager = {
        let m = CBCentralManager(delegate: self, queue: nil)
        return m
    }()
    
    @Published var peripherals: [CBPeripheral] = []
    @Published var isScanning = false
    @Published var connectedPeripheral: CBPeripheral? {
        didSet {
            connectedPeripheral?.delegate = self
            discoverServices()
        }
    }
    
    var myCharacteristic: CBCharacteristic?
    var theCharacteristic: CBCharacteristic?
    var theService: CBService?

    
    var txCharacteristic: CBCharacteristic?
    var rxCharacteristic: CBCharacteristic?
    
    var canSend: Bool {
        return txCharacteristic != nil
    }
    
    func startScanning() {
        print("Started scanning")
        isScanning = true
        manager.scanForPeripherals(withServices: nil, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.stopScanning()
        }
    }
    
    func stopScanning() {
        print("Stopped scanning")
        isScanning = false
        manager.stopScan()
        peripherals = []
    }
    
    func connect(to peripheral: CBPeripheral) {
        manager.connect(peripheral, options: nil)
    }
    
    func disconnect(peripheral: CBPeripheral) {
        connectedPeripheral = nil
        txCharacteristic = nil
        rxCharacteristic = nil
        if let connected = connectedPeripheral {
            manager.cancelPeripheralConnection(connected)
        }
    }
    
    func getConnectedPeripheral() -> CBPeripheral {
        return connectedPeripheral!
    }
    
    struct Message: Codable {
        let message: String
        let code: Int
    }
    
    func writeValue(message: String) {
//        let data = Data(message.utf8)
        let data = Data(message.utf8)
//        let message = Message(message: message, code: 200)
        
        
        
        if let connected = connectedPeripheral, let tx = theCharacteristic {
            print("sending...")
            connected.writeValue(data, for: tx, type: .withoutResponse)
        }
    }
    
    func readValue() -> String {

        return String(NSString(data: myCharacteristic!.value!, encoding: String.Encoding.utf8.rawValue)!)
            
    }
    
    func discoverServices() {
        connectedPeripheral?.discoverServices(nil)
    }
    
    func discoverCharacteristics(for service: CBService) {
        connectedPeripheral?.discoverCharacteristics(nil, for: service)
    }
}

extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Manager did update state:", central.state.rawValue, central.state)
        guard central.state == .poweredOn else {
            return
        }
        
        startScanning()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("didDiscover: \(peripheral.name ?? "")")
        self.peripherals.append(peripheral)
        
        if (peripheral.name == "SH-HC-08") {
        //if (peripheral.name == "David’s MacBook Pro") {
            manager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect: \(peripheral.name ?? "")")
        stopScanning()
        
        connectedPeripheral = peripheral
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect: \(peripheral.name ?? ""), error: \(error?.localizedDescription ?? "")")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == connectedPeripheral {
            //connectedPeripheral = nil
        }
        print("didDisconnectPeripheral: \(peripheral.name ?? ""), error: \(error?.localizedDescription ?? "")")
    }
}

extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("didDiscoverServices: error \(error)")
            return
        }
        
        guard let services = peripheral.services else {
            print("no services")
            return
        }
        
        print("didDiscoverServices: \(services.count)")
        
        print("----------- START DISCOVERING SERVICES -----------")
        for service in services {
          print(service)
            
            
          theService = service
        }
        print("----------- DONE DISCOVERING SERVICES -----------")
        
        
        services.forEach {
            discoverCharacteristics(for: $0)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("didDiscoverDescriptorsFor")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("didDiscoverCharacteristicsFor: error \(error)")
            return
        }
        
        guard let characteristics = service.characteristics else {
            print("no characteristics")
            return
        }
        
        print("^^^^^^^^^^^^ START DISCOVERING CHARS ^^^^^^^^^^^^")
        for characteristic in characteristics {
            print(characteristic)

            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
                /// GET RID OFF
                if (myCharacteristic == nil) { myCharacteristic = characteristic }
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.write) {
                print("\(characteristic.uuid): properties contains .write")
                peripheral.setNotifyValue(true, for: characteristic)
            }
            
            theCharacteristic = characteristic
        }
                
        print("^^^^^^^^^^^^^ DONE DISCOVERING CHARS ^^^^^^^^^^^^^^^")

    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic == rxCharacteristic {
            if let value = characteristic.value {
                let string = String(decoding: value, as: UTF8.self)
                print("Value Recieved: \(string)")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("didWriteValueFor: error \(error)")
            return
        }
        
        print("Message sent")
    }
}
