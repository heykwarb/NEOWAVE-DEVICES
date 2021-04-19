//
//  NEOWAVE_DEVICESApp.swift
//  NEOWAVE DEVICES
//
//  Created by Yohei Kuwabara on 2021/01/15.
//

import SwiftUI

@main
struct NEOWAVE_DEVICESApp: App {
    @ObservedObject private var bleManager = BLEManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
