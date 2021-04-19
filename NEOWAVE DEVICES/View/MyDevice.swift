//
//  AddDevice.swift
//  NEOWAVE Kicks
//
//  Created by Yohey Kuwabara on 2021/01/17.
//

import SwiftUI

struct MyDevice: View, MyProtocol {
    @ObservedObject var bleManager = BLEManager()
    
    //show view
    @State var showAddDevice = false
    @State var showList = false
    @State var showDetail = false
    
    // device details
    @State var swooshColor = Color.blue
    @State var swooshColor_R = Color.blue
    @State var neonText = Color("neonText")
    @State var bgColor = Color("bgColor")
    @State var pattern: String = "Standard"
    
    var columns = Array(repeating: GridItem(.flexible(),spacing: 10), count: 2)
    
    //haptic
    let generator = UINotificationFeedbackGenerator()
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    
    // functions
    func searchDevice(){
        bleManager.startScanning()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            bleManager.stopScanning()
        }
    }
    
    func connectDevice() {
        if bleManager.peripheralisConnected == false{
            bleManager.connect(peripheral: bleManager.scannedPeripheral!)
        } else {
            bleManager.disconnect(peripheral: bleManager.scannedPeripheral!)
        }
        if showAddDevice == true {
            self.showAddDevice.toggle()
        }
        impactLight.impactOccurred()
    }
    
    func switchButton() {
        if bleManager.peripheralisConnected == true{
            self.bleManager.led.toggle()
            
            if bleManager.led == true{
                playSound(sound: "on_306", type: "mp3")
            }else {
                playSound(sound: "off_306", type: "mp3")
            }
            
            bleManager.switchLED()
            self.generator.notificationOccurred(.success)
        }
    }
    
    func showDetails() {
        self.showDetail.toggle()
        impactLight.impactOccurred()
    }
    
    //func AddDevice
    func onDismissAddDevice() {
        bleManager.stopScanning()
        self.showList.toggle()
    }
    
    func addDeviceButton() {
        ///self.showAddDevice.toggle()
        searchDevice()
        impactLight.impactOccurred()
    }
    
    //color
    func colorRGB() {
        bleManager.colorRed = Int(Double(swooshColor.components.red * 255))
        bleManager.colorGreen = Int(Double(swooshColor.components.green * 255))
        bleManager.colorBlue = Int(Double(swooshColor.components.blue * 255))
        bleManager.sendColor()
    }
    
    @GestureState private var didLongPress: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack{
                //background
                RadialGradient(gradient: Gradient(colors: [Color.black, bgColor]), center: .bottom, startRadius: 100, endRadius: 900)
                    .edgesIgnoringSafeArea(.all)
                
                //LED Color when is On
                if bleManager.led == true && bleManager.peripheralisConnected == true{
                    RadialGradient(gradient: Gradient(colors: [swooshColor, Color.black.opacity(0)]), center: .bottom, startRadius: 10, endRadius: 600)
                        .edgesIgnoringSafeArea(.all)
                }
                
                //Main View
                if bleManager.scannedPeripheral == nil{
                    ///Button(action: {addDeviceButton()}){
                        ///AddDeviceButton2(neonText: $neonText)
                    ///}
                    Text("Can't find your device")
                        .font(.headline)
                        .foregroundColor(neonText)
                        .shadow(color: neonText, radius: 6 )
                        .opacity(0.5)
                    
                    
                }else {
                    GeometryReader { geo in
                        ScrollView(.horizontal){
                            HStack(spacing: geo.size.width/12){
                                ForEach(bleManager.scannedPeripherals) { peripheral in
                                    //Device Cards
                                    VStack{
                                        HStack(){
                                            //Device Name
                                            Text(peripheral.name)
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(neonText)
                                                .shadow(color: neonText, radius: 6)
                                            
                                            Spacer()
                                            
                                            //Status
                                            DeviceStatus1(deviceStatus: $bleManager.peripheralisConnected)
                                        }
                                        .padding()
                                        
                                        Spacer()
                                        
                                        HStack{
                                            Text("Brightness:")
                                                .foregroundColor(neonText)
                                                .shadow(color: neonText, radius: 6)
                                            
                                            Spacer()
                                            
                                            Text("\(String(Int(bleManager.brightness)))/10")
                                                .foregroundColor(neonText)
                                                .shadow(color: neonText, radius: 6)
                                        }
                                        .padding()
                                        
                                        HStack{
                                            Text("Pattern:")
                                                .foregroundColor(neonText)
                                                .shadow(color: neonText, radius: 6)
                                            
                                            Spacer()
                                            
                                            Text(pattern)
                                                .foregroundColor(neonText)
                                                .shadow(color: neonText, radius: 6)
                                        }
                                        .padding()
                                        
                                        HStack{
                                            Text("Color:")
                                                .foregroundColor(neonText)
                                                .shadow(color: neonText, radius: 6)
                                            
                                            Spacer()
                                            
                                            Text(String(swooshColor.description))
                                                .foregroundColor(neonText)
                                                .shadow(color: neonText, radius: 6)
                                        }
                                        .padding()
                                        
                                        //Batteries
                                        
                                    }
                                    .padding()
                                    .frame(width: geo.size.width/1.25, height: geo.size.height/1.6)
                                    .background(BlurView())
                                    .cornerRadius(24)
                                    .shadow(color: neonText, radius: 12)
                                    .onTapGesture{showDetails()}
                                    .onLongPressGesture(minimumDuration: 0.1){switchButton()}
                                    .sheet(isPresented: $showDetail, content: {
                                        DeviceDetails(ledIsOn: $bleManager.led, deviceStatus: $bleManager.peripheralisConnected, brightness: $bleManager.brightness, patternName: $pattern, selectedPattern: $bleManager.patterns, swooshColor: $swooshColor, swooshColor_R: $swooshColor_R,  neonText: $neonText, delegate: self, bleManager: bleManager)
                                    })
                                }
                            }
                            .padding(.all, geo.size.width/10)
                        }
                    }
                }
            }
            .navigationBarTitle("NEOWAVE")
            .navigationBarItems(trailing:
                Button(action: {addDeviceButton()}){
                    AddDeviceButton1(neonText: $neonText)
                }
                .sheet(isPresented: $showAddDevice, onDismiss: onDismissAddDevice, content: {
                    AddDevice(showAddDevice: $showAddDevice, ledIsOn: $bleManager.led, delegate: self)
                }))
        }
    }
}

struct MyDevice_Previews: PreviewProvider {
    static var previews: some View{
        MyDevice()
    }
}

protocol MyProtocol {
    func switchButton()
    func colorRGB()
    func connectDevice()
}

struct AddDeviceButton1: View {
    @Binding var neonText: Color
    var body: some View{
        HStack{
            Text("Search")
                .foregroundColor(neonText)
                .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                .shadow(color: neonText, radius: 6)
            
            Image(systemName: "plus.square.fill")
                .foregroundColor(neonText)
                .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                .shadow(color: neonText, radius: 6)
        }
    }
}

struct AddDeviceButton2: View{
    @Binding var neonText: Color
    var body: some View{
        Text("Add Device")
            .foregroundColor(neonText)
            .font(.title2)
            .shadow(color: neonText, radius: 6)
            .padding()
            .background(BlurView())
            .cornerRadius(12)
            .shadow(radius: 12)
    }
    
}

struct batteryView: View {
    @Binding var neonText: Color
    var body: some View{
        HStack{
            VStack{
                Image(systemName: "battery.100")
                    .font(.title)
                    .foregroundColor(neonText)
                    .shadow(color: neonText, radius: 6)
                    .padding()
                
                Text("L")
                    .font(.title2)
                    .foregroundColor(neonText)
                    .shadow(color: neonText, radius: 6)
                    .padding()
            }
            Spacer()
            VStack{
                Image(systemName: "battery.100")
                    .font(.title)
                    .foregroundColor(neonText)
                    .shadow(color: neonText, radius: 6)
                    .padding()
                
                Text("R")
                    .font(.title2)
                    .foregroundColor(neonText)
                    .shadow(color: neonText, radius: 6)
                    .padding()
            }
        }
    }
}
