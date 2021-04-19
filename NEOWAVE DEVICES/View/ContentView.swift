//
//  hhome.swift
//  NEOWAVE Kicks
//
//  Created by Yohey Kuwabara on 2021/01/19.
//

import SwiftUI

extension Color {
    static let textColor = Color("text")
    static let buttonColor = Color("button")
}

struct ContentView: View {
    var body: some View {
        MyDevice()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View{
        ContentView()
    }
}
