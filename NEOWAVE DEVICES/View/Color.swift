//
//  Color.swift
//  NEOWAVE Kicks
//
//  Created by Yohey Kuwabara on 2021/02/15.
//

import Foundation
import SwiftUI

extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        
        
        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            // You can handle the failure here as you want
            if r < 0 {
                r = 0
            }
            if g < 0 {
                g = 0
            }
            if b < 0 {
                b = 0
            }
            if 1 < r {
                r = 1
            }
            if 1 < g {
                g = 1
            }
            if 1 < b {
                b = 1
            }
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }
}
