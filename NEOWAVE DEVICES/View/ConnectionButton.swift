//
//  ConnectionButton.swift
//  NEOWAVE Kicks
//
//  Created by Yohey Kuwabara on 2021/01/16.
//

import SwiftUI

struct ConnectionButton: View {
    @ObservedObject var bleManager = BLEManager()
    @Binding var deviceStatus: Bool
    @Binding var ledStatus: Bool
    
    var body: some View {
        HStack{
            Text("LED")
            if ledStatus == true {
                Image(systemName: "circle.fill")
                    .blur(radius: 2)
                    .foregroundColor(.green)
            } else {
                Image(systemName: "circle.fill")
                    .blur(radius: 2)
                    .foregroundColor(.red)
            }
            
        }
        .padding(.all, 10.0)
        .background(BlurView())
        .cornerRadius(10)
        .shadow(radius: 6)
        .padding()
    }
}

