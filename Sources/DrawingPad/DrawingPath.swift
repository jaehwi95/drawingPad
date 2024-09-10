//
//  DrawingPath.swift
//
//
//  Created by Jaehwi Kim on 2024/07/08.
//

import SwiftUI
import UIKit

/// Struct that manages a drawing path composed of dots and lines.
///
///
/// - Parameters:
///   - segments: An array of tuples where each tuple contains an array of points (CGPoints) and the count of those points. 
///     This represents the different segments of the path.
///   - linePoints: An array of points representing the current line being drawn.
public struct DrawingPath: Sendable {
    private var lineSegments: [(points: [CGPoint], count: Int)] = []
    private var linePoints: [CGPoint] = []
    
    public init(
        lineSegments: [(points: [CGPoint], count: Int)] = [],
        linePoints: [CGPoint] = []
    ) {
        self.lineSegments = lineSegments
        self.linePoints = linePoints
    }
    
    /// Check if the drawing path is empty.
    public var isEmpty: Bool {
        lineSegments.isEmpty
    }
    
    /// Clear all segments and linePoints.
    public mutating func clear() {
        self.lineSegments.removeAll()
        self.linePoints.removeAll()
    }
    
    /// Adds a dot to the drawing path.
    ///
    /// - Parameters:
    ///   - point: The CGPoint representing the location of the dot.
    mutating func addDot(_ point: CGPoint) {
        lineSegments.append(
            (points: [point], count: 1)
        )
    }
    
    /// Adds a point to the current line being drawn.
    ///
    /// - Parameters:
    ///    - point: The CGPoint representing the location to add to the current line.
    /// This method appends the point to the `linePoints` array without creating a new segment.
    mutating func addLine(_ point: CGPoint) {
        linePoints.append(point)
    }
    
    /// Ends the current line and stores it as a segment.
    ///
    /// This method appends the current `linePoints` array as a segment to the `segments` array,
    /// and then clears the `linePoints` array.
    mutating func endLine() {
        guard !linePoints.isEmpty else { return }
        lineSegments.append(
            (points: linePoints, count: linePoints.count)
        )
        linePoints.removeAll()
    }
    
    /// Generates a SwiftUI `Path` object representing the drawing path.
    ///
    /// This computed property iterates over the `linePoints` and `segments` arrays to create a `Path` object.
    /// It handles both individual dots and lines.
    var path: Path {
        var path = Path()
        
        // Handles showing line being drawn.
        if !linePoints.isEmpty {
            if let firstPoint = linePoints.first {
                path.move(to: firstPoint)
                linePoints.forEach { point in
                    path.addLine(to: point)
                }
            }
        }
        
        // Iterate over all segments to add them to the path.
        lineSegments.forEach { segment in
            if let firstPoint = segment.points.first {
                path.move(to: firstPoint)
                segment.points.forEach { point in
                    path.addLine(to: point)
                }
            }
        }
        return path
    }
}

public extension DrawingPath {
    /// Extracts a UIImage from the drawing path.
    ///
    /// - Parameters:
    ///   - strokeColor: The color of the stroke.
    ///   - lineWidth: The width of the line.
    /// - Returns: A UIImage representing the drawing path.
    func extractUIImage(strokeColor: Color, lineWidth: CGFloat) -> UIImage {
        let cgPath: CGPath = self.path.cgPath
        let boundingBox = cgPath.boundingBox
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: boundingBox.width+lineWidth, height: boundingBox.height+lineWidth))
        return renderer.image { context in
            let cgContext = context.cgContext
            cgContext.setStrokeColor(UIColor(strokeColor).cgColor)
            cgContext.setLineWidth(lineWidth)
            cgContext.translateBy(x: -(boundingBox.origin.x-(lineWidth/2)), y: -(boundingBox.origin.y-(lineWidth/2)))
            cgContext.setLineCap(.round)
            cgContext.beginPath()
            cgContext.addPath(cgPath)
            cgContext.drawPath(using: .stroke)
        }
    }
    
    /// Extracts a base64-encoded string from the drawing path.
    ///
    /// - Parameters:
    ///   - strokeColor: The color of the stroke.
    ///   - lineWidth: The width of the line.
    /// - Returns: A base64-encoded string representing the drawing path as a PNG image.
    func extractBase64String(strokeColor: Color, lineWidth: CGFloat) -> String {
        let uiImage = extractUIImage(strokeColor: strokeColor, lineWidth: lineWidth)
        return uiImage.pngData()?.base64EncodedString() ?? ""
    }
}
