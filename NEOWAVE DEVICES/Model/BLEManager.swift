
//
//  Bluetooth.swift
//  RaspBLE
//
//  Created by webmaster on 2020/07/12.
//  Copyright © 2020 SERVERNOTE.NET. All rights reserved.
//
 
import Foundation
import CoreBluetooth
 
struct ScannedPeripherals: Identifiable, Codable {
    let id: Int
    let name: String
    let rssi: Int
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var myCentral: CBCentralManager!
    @Published var isScanning = false
    @Published var btStatus = false
    
    //peripherals
    @Published var scannedPeripherals = [ScannedPeripherals]()
    @Published var scannedPeripheral: CBPeripheral?
    @Published var peripheralisConnected: Bool = false
    @Published var displayName: String?
    @Published var didConnectPericheral: CBPeripheral?
    
    //characteristics
    @Published var switchCharacteristic: CBCharacteristic?
    @Published var brightnessCharacteristic: CBCharacteristic?
    @Published var patternCharacteristic: CBCharacteristic?
    @Published var redCharacteristic: CBCharacteristic?
    @Published var greenCharacteristic: CBCharacteristic?
    @Published var blueCharacteristic: CBCharacteristic?
    @Published var redCharacteristic_R: CBCharacteristic?
    @Published var greenCharacteristic_R: CBCharacteristic?
    @Published var blueCharacteristic_R: CBCharacteristic?
    
    //characteristic writeValue
    @Published var led: Bool = false
    @Published var brightness = 10.0
    @Published var patterns: Int = 1
    @Published var color: Int?
    @Published var colorRed: Int = 52
    @Published var colorBlue: Int = 120
    @Published var colorGreen: Int = 246
    @Published var colorRed_R: Int = 52
    @Published var colorBlue_R: Int = 120
    @Published var colorGreen_R: Int = 246
    
    
    // UART Service UUID
    let uartServiceUUIDString = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"

    //Characteristics UUID
    // UART SWITCH UUID
    let uartSwitchCharUUIDString = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
    // UART BRIGHTNESS UUID
    let uartBrightnessCharUUIDString = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
    // UART PATTERNS UUID
    let uartPatternsCharUUIDString = "6E400004-B5A3-F393-E0A9-E50E24DCCA9E"
    // UART COLOR RED UUID
    let uartRedCharUUIDString = "6E400005-B5A3-F393-E0A9-E50E24DCCA9E"
    // UART COLOR GREEN UUID
    let uartGreenCharUUIDString = "6E400006-B5A3-F393-E0A9-E50E24DCCA9E"
    // UART COLOR BLUE UUID
    let uartBlueCharUUIDString = "6E400007-B5A3-F393-E0A9-E50E24DCCA9E"
    // UART COLOR RED RIGHT UUID
    let uartRedCharUUIDString_R = "6E400008-B5A3-F393-E0A9-E50E24DCCA9E"
    // UART COLOR GREEN RIGHT UUID
    let uartGreenCharUUIDString_R = "6E400009-B5A3-F393-E0A9-E50E24DCCA9E"
    // UART COLOR BLUE RIGHT UUID
    let uartBlueCharUUIDString_R = "6E400010-B5A3-F393-E0A9-E50E24DCCA9E"
    
    override init() {
        super.init()
            myCentral = CBCentralManager(delegate: self, queue: nil)
            myCentral.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
         btStatus = true
        } else {
         btStatus = false
        }
        ///didConnectPericheral = retrievePeripher
        ///myCentral.retrievePeripherals(withIdentifiers: [UUID])
    }

    //whenDidDiscover
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        var peripheralName: String!
       
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String, name.lowercased().contains("neowaveswoosh_l") {
            peripheralName = "Swoosh L&R"
            displayName = peripheralName
            scannedPeripheral = peripheral
            let newPeripheral = ScannedPeripherals(id: scannedPeripherals.count, name: peripheralName, rssi: RSSI.intValue)
            print(newPeripheral)
            scannedPeripherals.append(newPeripheral)
            //set displayName
            ///let neowave = scannedPeripheral?.name?.index(scannedPeripheral?.name?.neowave!, offsetBy: 7)
            ///displayName = scannedPeripheral?.name?.index(after: neowave)
            ///print("got displayName")
            
            scannedPeripheral?.delegate = self
            scannedPeripheral?.discoverServices(nil)
        }
        
    }
    
    //whenDidConnect
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([CBUUID(string: uartServiceUUIDString)])
        peripheralisConnected = true
        print("connected")
    }
    
    //whenDidDisconnect
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        peripheralisConnected = false
        led = false
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
    
    //whenDiscoveredService
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("discoveredService")
        let serviceUUID: CBUUID = CBUUID(string: uartServiceUUIDString)
        
        if let error = error {
            print("error: \(error)")
            return
        }
        
        for service in scannedPeripheral!.services! {
            if(service.uuid == serviceUUID) {
                scannedPeripheral?.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    //whenDiscoveredCharacteristics
    func peripheral(_ peripheral: CBPeripheral,
                      didDiscoverCharacteristicsFor service: CBService,
                      error: Error?) {
        for characteristic in service.characteristics!{
            if characteristic.uuid.uuidString == uartSwitchCharUUIDString {
                switchCharacteristic = characteristic
                print("discovered Switch Characteristic")
            }
            if characteristic.uuid.uuidString == uartBrightnessCharUUIDString {
                brightnessCharacteristic = characteristic
                print("discovered Brightness Characteristic")
            }
            if characteristic.uuid.uuidString == uartPatternsCharUUIDString {
                patternCharacteristic = characteristic
                print("discovered Patterns Characteristic")
            }
            if characteristic.uuid.uuidString == uartRedCharUUIDString {
                redCharacteristic = characteristic
                print("discovered Red Characteristic")
            }
            if characteristic.uuid.uuidString == uartGreenCharUUIDString {
                greenCharacteristic = characteristic
                print("discovered Green Characteristic")
            }
            if characteristic.uuid.uuidString == uartBlueCharUUIDString {
                blueCharacteristic = characteristic
                print("discovered Blue Characteristic")
            }
            
            if characteristic.uuid.uuidString == uartRedCharUUIDString_R {
                redCharacteristic_R = characteristic
                print("discovered Red R Characteristic")
            }
            if characteristic.uuid.uuidString == uartGreenCharUUIDString_R {
                greenCharacteristic_R = characteristic
                print("discovered Green R Characteristic")
            }
            if characteristic.uuid.uuidString == uartBlueCharUUIDString_R {
                blueCharacteristic_R = characteristic
                print("discovered Blue R Characteristic")
            }
        }
        
    }
    
    private func peripheral(peripheral: CBPeripheral,
        didWriteValueForCharacteristic characteristic: CBCharacteristic,
        error: NSError?)
    {
        if let error = error {
            print("Write失敗...error: \(error)")
            return
        }

        print("Wrote")
    }
    
    func startScanning() {
         print("startScanning")
         myCentral.scanForPeripherals(withServices: nil, options: nil)
     }
    
    func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
    }
    
    func connect(peripheral: CBPeripheral) {
        myCentral.connect(scannedPeripheral!, options: nil)
        
    }
    
    func disconnect(peripheral: CBPeripheral) {
        myCentral.cancelPeripheralConnection(scannedPeripheral!)
    }
    
    //write Data
    func switchLED() {
        var value: String
        
        if led == true {
            value = "on"
            print("//////")
            print("LEDisOn")
        } else {
            value = "off"
            print("//////")
            print("LEDisOff")
        }
        
        let data = value.data(using: String.Encoding.utf8, allowLossyConversion:true)!
        scannedPeripheral?.writeValue(data, for: switchCharacteristic! , type: CBCharacteristicWriteType.withResponse)
        
        if led == true {
            sendBrightness()
            sendPatterns()
            sendColor()
        }
    }
    
    func sendBrightness() {
        var brightnessValue: String
        brightnessValue = String(Int(brightness))
        let data = brightnessValue.data(using: String.Encoding.utf8, allowLossyConversion:true)!
        scannedPeripheral?.writeValue(data, for: brightnessCharacteristic! , type: CBCharacteristicWriteType.withResponse)
        //print
        print("//////")
        print("brightness")
        print(Int(brightness))
        
    }
    
    func sendPatterns() {
        var patternValue: String
        patternValue = String(patterns)
        let data = patternValue.data(using: String.Encoding.utf8, allowLossyConversion:true)!
        scannedPeripheral?.writeValue(data, for: patternCharacteristic! , type: CBCharacteristicWriteType.withResponse)
        print("//////")
        print("pattern")
        print(String(patterns))
        
    }
    
    func sendColor() {
        let redValue:String = String(colorRed)
        let greenValue:String = String(colorGreen)
        let blueValue:String = String(colorBlue)
        
        let redData = redValue.data(using: String.Encoding.utf8, allowLossyConversion:true)!
        let greenData = greenValue.data(using: String.Encoding.utf8, allowLossyConversion:true)!
        let blueData = blueValue.data(using: String.Encoding.utf8, allowLossyConversion:true)!
        
        //write value
        scannedPeripheral?.writeValue(redData, for: redCharacteristic! , type: CBCharacteristicWriteType.withResponse)
        scannedPeripheral?.writeValue(greenData, for: greenCharacteristic! , type: CBCharacteristicWriteType.withResponse)
        scannedPeripheral?.writeValue(blueData, for: blueCharacteristic! , type: CBCharacteristicWriteType.withResponse)
        
        //print
        print("//////")
        print("color")
        print(String(colorRed))
        print(String(colorGreen))
        print(String(colorBlue))
        
    }
    
    func sendColor_R() {
        let redValue:String = String(colorRed_R)
        let greenValue:String = String(colorGreen_R)
        let blueValue:String = String(colorBlue_R)
        
        let redData = redValue.data(using: String.Encoding.utf8, allowLossyConversion:true)!
        let greenData = greenValue.data(using: String.Encoding.utf8, allowLossyConversion:true)!
        let blueData = blueValue.data(using: String.Encoding.utf8, allowLossyConversion:true)!
        
        //write value
        scannedPeripheral?.writeValue(redData, for: redCharacteristic_R! , type: CBCharacteristicWriteType.withResponse)
        scannedPeripheral?.writeValue(greenData, for: greenCharacteristic_R! , type: CBCharacteristicWriteType.withResponse)
        scannedPeripheral?.writeValue(blueData, for: blueCharacteristic_R! , type: CBCharacteristicWriteType.withResponse)
        
        //print
        print("//////")
        print("color R")
        print(String(colorRed_R))
        print(String(colorGreen_R))
        print(String(colorBlue_R))
        
    }
}
