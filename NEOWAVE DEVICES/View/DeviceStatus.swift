//
//  DeviceStatus.swift
//  NEOWAVE Kicks
//
//  Created by Yohey Kuwabara on 2021/02/10.
//

import SwiftUI

struct DeviceStatus1: View {
    @Binding var deviceStatus: Bool
    var body: some View {
        if deviceStatus == true{
            HStack{
                Image(systemName: "circle.fill")
                    .blur(radius: 2)
                    .foregroundColor(.green)
            }
            
        } else {
            Image(systemName: "circle.fill")
                .blur(radius: 2)
                .foregroundColor(.red)
        }
    }
}

struct DeviceStatus2: View {
    @Binding var deviceStatus: Bool
    @Binding var neonText: Color
    var body: some View {
        if deviceStatus == true{
            ZStack{
                Text("Connected")
                    .foregroundColor(neonText)
                Text("Connected")
                    .foregroundColor(neonText)
                    .blur(radius: 6)
            }
            
        } else {
            ZStack{
                Text("Disonnected")
                    .foregroundColor(neonText)
                Text("Disonnected")
                    .foregroundColor(neonText)
                    .blur(radius: 6)
            }
        }
    }
}

struct DeviceStatus3: View {
    @Binding var deviceStatus: Bool
    @Binding var neonText: Color
    let generator = UINotificationFeedbackGenerator()
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View{
        HStack{
            DeviceStatus2(deviceStatus: $deviceStatus, neonText: $neonText)
            DeviceStatus1(deviceStatus: $deviceStatus)
        }
        
    }
}


