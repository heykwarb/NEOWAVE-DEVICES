//
//  DeviceCard.swift
//  NEOWAVE Kicks
//
//  Created by Yohey Kuwabara on 2021/01/19.
//

import SwiftUI

struct DeviceCard: View {
    
    @Binding var showMyKicks: Bool
    @ObservedObject var bleManager = BLEManager()

    var body: some View {
        ZStack{
            ///Text(deviceModel.name)
                ///.font(.title2)
                ///.fontWeight(.bold)
                ///.foregroundColor(.black)
                ///.multilineTextAlignment(.center)
                ///.padding()
            VStack{
                HStack{
                    Text(devices.name)
                        .font(.title2)
                        .foregroundColor(.black)
                    Spacer()
                    if devices.status == true {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.green)
                            .blur(radius: 2.0)
                    } else {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.red)
                            .blur(radius: 2.0)
                    }
                    
                }
                .padding(.all)
                Spacer()
            }
        }
        .frame(width: 160.0, height: 160.0)
        .background(BlurView())
        .cornerRadius(12)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding(.all)
    }
}
