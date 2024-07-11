//
//  ContentView.swift
//  ExampleDrawingPad
//
//  Created by Jaehwi Kim on 2024/07/08.
//

import SwiftUI
import DrawingPad

struct ContentView: View {
    @State private var drawingPath1 = DrawingPath()
    @State private var drawingPath2 = DrawingPath()
    
    var body: some View {
        ScrollView {
            VStack {
                DrawingPad(drawingPath: $drawingPath1, lineWidth: 4, strokeColor: Color.black)
                    .frame(height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray)
                    )
                HStack(spacing: 40) {
                    Button(
                        action: {
                            drawingPath1.clear()
                        },
                        label: {
                            Text("Clear")
                        }
                    )
                    HStack {
                        Image(systemName: drawingPath1.isEmpty ? "xmark" : "checkmark")
                        Text(drawingPath1.isEmpty ? "Empty" : "Not Empty")
                    }
                }
                Image(uiImage: drawingPath1.extractUIImage(strokeColor: Color.black, lineWidth: 4))
                    .border(.green)
                DrawingPad(drawingPath: $drawingPath2, lineWidth: 2, strokeColor: Color.red, backgroundColor: Color.yellow.opacity(0.2))
                    .frame(height: 300)
            }
            .frame(height: 1000)
        }
        .padding()
    }
}
