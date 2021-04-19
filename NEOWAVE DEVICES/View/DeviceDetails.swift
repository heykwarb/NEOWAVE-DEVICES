//
//  MyKicks.swift
//  NEOWAVE Kicks
//
//  Created by Yohey Kuwabara on 2021/01/17.
//

import SwiftUI
import SceneKit

struct DeviceDetails: View {
    
    @Binding var ledIsOn: Bool
    //BLEManager
    @Binding var deviceStatus: Bool
    @Binding var brightness: Double
    @State var pattern1 = "Standard"
    @State var pattern2 = "Blink"
    @State var pattern3 = "Wave"
    @State var pattern4 = "Rainbow"
    @State var pattern5 = "Deep Breath"
    @Binding var patternName: String
    @Binding var selectedPattern: Int
    @Binding var swooshColor: Color
    @Binding var swooshColor_R: Color
    @Binding var neonText: Color
    
    ///@Binding var deviceName: String
    var delegate: MyProtocol
    @ObservedObject var bleManager: BLEManager
    
    let generator = UINotificationFeedbackGenerator()
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View{
        NavigationView{
            VStack{
                if deviceStatus == true {
                    //Swoosh
                    ///SceneView(scene: SCNScene(named: "NikeSwoosh.usdz"), options: [.autoenablesDefaultLighting,.allowsCameraControl])
                        ///.frame(width: geo.size.width/1.5, height: geo.size.width/1.5)
                        ///.cornerRadius(24)
                    Form {
                        Section {
                            //LED Switch
                            Toggle(isOn: $ledIsOn) {
                                Text("LED")
                            }
                            .onChange(of: ledIsOn, perform: { value in
                                bleManager.switchLED()
                                if bleManager.led == true{
                                    playSound(sound: "on_306", type: "mp3")
                                }else {
                                    playSound(sound: "off_306", type: "mp3")
                                }
                            })
                        }
                        if ledIsOn == true {
                            //Left details
                            Section(header: Text("")) {
                                //Brightness
                                HStack{
                                    Image(systemName: "sun.min")
                                        .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(.textColor)
                                    Slider(value: $brightness, in: 1...10, step: 1)
                                        .onChange(of: brightness, perform: { value in
                                            bleManager.sendBrightness()
                                            impactLight.impactOccurred()
                                        })
                                    Image(systemName: "sun.max")
                                        .font(.title2)
                                        .foregroundColor(.textColor)
                                }
                                
                                //Patterns
                                Picker(selection: $selectedPattern, label: Text("Patterns")) {
                                    Text(pattern1).tag(1)
                                    Text(pattern2).tag(2)
                                    ///Text(pattern3).tag(3)
                                    ///Text(pattern4).tag(4)
                                    Text(pattern5).tag(5)
                                }
                                .onChange(of: selectedPattern, perform: { value in
                                    bleManager.sendPatterns()
                                    if selectedPattern == 1{
                                        patternName = pattern1
                                    } else if selectedPattern == 2{
                                        patternName = pattern2
                                    } else if selectedPattern == 3{
                                        patternName = pattern3
                                    } else if selectedPattern == 4{
                                        patternName = pattern4
                                    } else if selectedPattern == 5{
                                        patternName = pattern5
                                    }
                                })
                                
                                //Color
                                ColorPicker(selection: $swooshColor){
                                    Text("Color")
                                }
                                .onChange(of: swooshColor, perform: { value in
                                    delegate.colorRGB()
                                    //red
                                    print("red")
                                    print(swooshColor.components.red)
                                    print($bleManager.colorRed)
                                    
                                    //green
                                    print("green")
                                    print(swooshColor.components.green)
                                    print($bleManager.colorGreen)
                                    
                                    //blue
                                    print("blue")
                                    print(swooshColor.components.blue)
                                    print($bleManager.colorBlue)
                                })
                            }
                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                        }
                    }
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }else {
                    Button(action: {delegate.connectDevice()}){
                        Text("Connect to this device")
                            .foregroundColor(neonText)
                            .font(.title2)
                            .shadow(color: neonText, radius: 6)
                    }
                    .padding()
                    .background(BlurView())
                    .cornerRadius(12)
                    .shadow(radius: 12)
                }
            }
            .navigationBarTitle(bleManager.displayName!)
            .navigationBarItems(trailing: DeviceStatus3(deviceStatus: $deviceStatus, neonText: $neonText)
                                    .onTapGesture {
                                        delegate.connectDevice()
                                        impactLight.impactOccurred()
                                    })
                                    
                                    
        }
    }
}


