//
//  slider.swift
//  NEOWAVE Kicks
//
//  Created by Yohey Kuwabara on 2021/02/01.
//

import SwiftUI

struct BrightnessSlider: View {
    @ObservedObject var bleManager = BLEManager()
    @Binding var brightness: Double
    var body: some View {
        ///Text("brightness")
            ///.foregroundColor(.textColor)
        HStack{
            Image(systemName: "sun.min")
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                .foregroundColor(.textColor)
            Slider(value: $brightness, in: 1...10, step: 1)
                .onChange(of: brightness, perform: { value in
                    print(brightness)
                    bleManager.sendBrightness()
                })
            Image(systemName: "sun.max")
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                .foregroundColor(.textColor)
            
        }
    }
}
