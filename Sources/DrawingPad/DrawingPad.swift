//
//  DrawingPad.swift
//
//
//  Created by Jaehwi Kim on 2024/07/08.
//

import SwiftUI

public struct DrawingPad: View {
    @Binding private var drawingPath: DrawingPath
    private let lineWidth: CGFloat
    private let strokeColor: Color
    private let backgroundColor: Color
    @State private var drawingBounds: CGRect = .zero
    
    public var body: some View {
        ZStack {
            backgroundColor
                .background(
                    GeometryReader { geometry in
                        Color.clear.preference(
                            key: FramePreferenceKey.self,
                            value: geometry.frame(in: .local)
                        )
                    }
                )
                .onPreferenceChange(FramePreferenceKey.self) { bounds in
                    updateDrawingBounds(bounds: bounds)
                }
            DrawingShape(drawingPath: drawingPath)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(strokeColor)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    print("jaebi: onchanged")
                    if drawingBounds.contains(value.location) {
                        drawingPath.addLine(value.location)
                    } else {
                        drawingPath.endLine()
                    }
                }
                .onEnded { _ in
                    print("jaebi: onEnded")
                    drawingPath.endLine()
                }
        )
    }
    
    private func updateDrawingBounds(bounds: CGRect) {
        let validBounds: CGRect = CGRect(
            x: lineWidth / 2,
            y: lineWidth / 2,
            width: bounds.size.width - lineWidth,
            height: bounds.size.height - lineWidth
        )
        drawingBounds = validBounds
    }
}

extension DrawingPad {
    public init(
        drawingPath: Binding<DrawingPath>,
        lineWidth: CGFloat,
        strokeColor: Color? = nil,
        backgroundColor: Color? = nil
    ) {
        self._drawingPath = drawingPath
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor ?? Color.black
        self.backgroundColor = backgroundColor ?? Color.white
    }
}

private struct DrawingShape: Shape {
    let drawingPath: DrawingPath
    
    func path(in rect: CGRect) -> Path {
        drawingPath.path
    }
}

private struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
