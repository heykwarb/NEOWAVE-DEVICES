//
//  BlurView.swift
//  WhoToday
//
//  Created by Yohey Kuwabara on 2020/11/27.
//

import SwiftUI

struct BlurView : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIVisualEffectView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurView>) {
        
    }
}
