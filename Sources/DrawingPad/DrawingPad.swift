import SwiftUI

public struct DrawingPad: View {
    private let lineWidth: CGFloat
    private let strokeColor: Color?
    private let backgroundColor: Color?
    @State private var drawingPath: DrawingPath
    @State private var drawingBounds: CGRect = .zero
    @GestureState private var location: CGPoint = .zero
    
    public var body: some View {
        VStack {
            ZStack {
                backgroundColor
                    .background(GeometryReader { geometry in
                        Color.clear.preference(
                            key: FramePreferenceKey.self,
                            value: geometry.frame(in: .local)
                        )
                    })
                    .onPreferenceChange(FramePreferenceKey.self) { bounds in
                        drawingBounds = bounds
                    }
                DrawingShape(drawingPath: drawingPath)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .foregroundColor(strokeColor)
            }
            .frame(height: 160)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if drawingBounds.contains(value.location) {
                            drawingPath.addLine(value.location)
                        } else {
                            drawingPath.endLine()
                        }
                    }
                    .onEnded { _ in
                        drawingPath.endLine()
                    }
            )
            .simultaneousGesture(
                SpatialTapGesture()
                    .onEnded{ value in
                        if drawingBounds.contains(value.location) {
                            drawingPath.addDot(value.location)
                        }
                    }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray)
            )
        }
    }
}

extension DrawingPad {
    public init(
        lineWidth: CGFloat,
        strokeColor: Color? = nil,
        backgroundColor: Color? = nil
    ) {
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor ?? Color.black
        self.backgroundColor = backgroundColor ?? Color.white
        self.drawingPath = DrawingPath(dotWidth: self.lineWidth)
    }
}

struct DrawingShape: Shape {
    let drawingPath: DrawingPath

    func path(in rect: CGRect) -> Path {
        drawingPath.path
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
