//
//  BTStatus.swift
//  NEOWAVE Kicks
//
//  Created by Yohey Kuwabara on 2021/02/01.
//

import SwiftUI

struct BTStatus: View {
    @ObservedObject var bleManager = BLEManager()
    var body: some View{
        if bleManager.btStatus == true {
            Image(systemName: "circle.fill")
                .blur(radius: 2)
                .foregroundColor(.green)
        } else {
            Image(systemName: "circle.fill")
                .blur(radius: 2)
                .foregroundColor(.red)
        }
    }
}

struct BTStatus_Previews: PreviewProvider {
    static var previews: some View {
        BTStatus()
    }
}
