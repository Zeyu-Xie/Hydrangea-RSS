//
//  LoadingView.swift
//  Hydrangea RSS
//
//  Created by Zeyu Xie on 2024/8/18.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .foregroundColor(.gray.opacity(0.5))
                .frame(width: 50, height: 50)
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
    }
}
