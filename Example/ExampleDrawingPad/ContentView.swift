//
//  ContentView.swift
//  ExampleDrawingPad
//
//  Created by Jaehwi Kim on 2024/07/08.
//

import SwiftUI
import DrawingPad

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                DrawingPad(lineWidth: 20)
                DrawingPad(lineWidth: 4, strokeColor: Color.red)
            }
            .frame(height: 1000)
        }
        .padding()
    }
}
