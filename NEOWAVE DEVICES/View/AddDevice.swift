//
//  AddDevice.swift
//  NEOWAVE Kicks
//
//  Created by Yohey Kuwabara on 2021/02/10.
//

import SwiftUI

struct AddDevice: View {
    @ObservedObject var bleManager = BLEManager()
    @State var deviceStatus = false
    @Binding var showAddDevice: Bool
    @Binding var ledIsOn: Bool
    var delegate: MyProtocol
    var columns = Array(repeating: GridItem(.flexible(),spacing: 10), count: 2)
    
    func searchDevice(){
        bleManager.startScanning()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            bleManager.stopScanning()
        }
    }
    
    func connectDevice() {
        if deviceStatus == false{
            bleManager.connect(peripheral: bleManager.scannedPeripheral!)
            self.deviceStatus.toggle()
        } else {
            bleManager.disconnect(peripheral: bleManager.scannedPeripheral!)
            self.deviceStatus.toggle()
        }
        if showAddDevice == true {
            self.showAddDevice.toggle()
        }
        ledIsOn = false
        
    }
    
    var body: some View {
        NavigationView{
            VStack{
                LazyVGrid(columns: columns,spacing: 20){
                    ForEach(bleManager.scannedPeripherals) { peripheral in
                        ZStack{
                            HStack(){
                                Text(peripheral.name)
                                DeviceStatus1(deviceStatus: $deviceStatus)
                            }
                        }
                        .frame(width: 160.0, height: 160.0)
                        .background(BlurView())
                        .cornerRadius(12)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .padding(.all)
                        .onTapGesture {
                            connectDevice()
                        }
                    }
                    .padding(.all)
                }
                Spacer()
                Button(action: {searchDevice()}) {
                    Text("search")
                }
            }
            .navigationBarTitle("NEOWAVE KICKS")
        }
    }
}

