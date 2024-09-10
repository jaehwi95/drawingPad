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
    @State private var drawingPath3 = DrawingPath()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Signature DrawingPad")
                        .font(.system(size: 24, weight: .bold))
                    DrawingPad(drawingPath: $drawingPath1, lineWidth: 4, strokeColor: Color.black)
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray)
                        )
                    HStack(spacing: 0) {
                        Button(
                            action: {
                                drawingPath1.clear()
                            },
                            label: {
                                Text("Clear")
                            }
                        )
                        .padding(20)
                        .buttonStyle(BorderedButtonStyle())
                        .frame(maxWidth: .infinity)

                        HStack {
                            Image(systemName: drawingPath1.isEmpty ? "xmark" : "checkmark")
                            Text(drawingPath1.isEmpty ? "Empty" : "Not Empty")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    Text("Image of the drawing")
                        .font(.system(size: 20, weight: .semibold))
                    Image(uiImage: drawingPath1.extractUIImage(strokeColor: Color.black, lineWidth: 4))
                        .border(.green)
                    Text("Base64String of the drawing")
                        .font(.system(size: 20, weight: .semibold))
                    Text("\(drawingPath1.extractBase64String(strokeColor: Color.black, lineWidth: 4))")
                        .font(.system(size: 12))
                }
                Divider()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Colored DrawingPad")
                        .font(.system(size: 24, weight: .bold))
                    DrawingPad(drawingPath: $drawingPath2, lineWidth: 2, strokeColor: Color.red, backgroundColor: Color.yellow.opacity(0.2))
                        .frame(height: 300)
                    Button(
                        action: {
                            drawingPath2.clear()
                        },
                        label: {
                            Text("Clear")
                        }
                    )
                    .padding(20)
                    .buttonStyle(BorderedButtonStyle())
                }
                Divider()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sized DrawingPad")
                        .font(.system(size: 24, weight: .bold))
                    HStack(spacing: 20) {
                        DrawingPad(drawingPath: $drawingPath3, lineWidth: 5, strokeColor: Color.blue)
                            .frame(width: 150, height: 300)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.pink)
                            )
                        Button(
                            action: {
                                drawingPath3.clear()
                            },
                            label: {
                                Text("Clear")
                            }
                        )
                        .padding(20)
                        .buttonStyle(BorderedButtonStyle())
                    }
                }
            }
            .padding()
        }
    }
}
