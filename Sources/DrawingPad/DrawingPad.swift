//
//  DrawingPad.swift
//
//
//  Created by Jaehwi Kim on 2024/07/08.
//

import SwiftUI

public struct DrawingPad: View {
    /// The binding to the drawing path that will be modified as the user draws.
    @Binding private var drawingPath: DrawingPath
    
    /// The width of the stroke line.
    private let lineWidth: CGFloat
    
    /// The color used for the stroke line.
    private let strokeColor: Color
    
    /// The color used for the background of the drawing pad.
    private let backgroundColor: Color
    
    /// The bounds within which drawing is allowed.
    @State private var drawingBounds: CGRect = .zero
    
    public var body: some View {
        ZStack {
            // Set the background color of the drawing pad.
            backgroundColor
                .background(
                    GeometryReader { geometry in
                        // Capture the frame of the drawing pad using a preference key.
                        Color.clear.preference(
                            key: FramePreferenceKey.self,
                            value: geometry.frame(in: .local)
                        )
                    }
                )
            // Update the bounds for drawing whenever the geometry changes.
                .onPreferenceChange(FramePreferenceKey.self) { bounds in
                    updateDrawingBounds(bounds: bounds)
                }
            // Render the current drawing path as a stroked shape.
            DrawingShape(drawingPath: drawingPath)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(strokeColor)
        }
        // Handle drag gestures to allow the user to draw on the pad.
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    // If the drag location is within bounds, add the point to the drawing path.
                    if drawingBounds.contains(value.location) {
                        drawingPath.addLine(value.location)
                    } else {
                        // If the drag exits bounds, end the current line.
                        drawingPath.endLine()
                    }
                }
                .onEnded { _ in
                    // End the current line when the drag gesture ends.
                    drawingPath.endLine()
                }
        )
    }
    
    /// Updates the drawing bounds, accounting for the stroke line width.
    ///
    /// - Parameter bounds: The bounds of the drawing pad.
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
    /// Initializes a new instance of the `DrawingPad` view.
    ///
    /// - Parameters:
    ///   - drawingPath: A binding to the drawing path.
    ///   - lineWidth: The width of the stroke line.
    ///   - strokeColor: The color of the stroke (default is black).
    ///   - backgroundColor: The color of the background (default is white).
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
    /// The drawing path that defines the shape.
    let drawingPath: DrawingPath
    
    /// Generates the path to be drawn in the provided rectangle.
    ///
    /// - Parameter rect: The area where the path will be drawn.
    /// - Returns: A `Path` object representing the drawing.
    func path(in rect: CGRect) -> Path {
        drawingPath.path
    }
}

private struct FramePreferenceKey: PreferenceKey {
    /// The default value for the frame preference.
    static var defaultValue: CGRect = .zero
    
    /// Reduces the value of the preference key by updating the current frame with the next frame.
    ///
    /// - Parameters:
    ///   - value: The current frame value.
    ///   - nextValue: A closure providing the next frame value.
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
