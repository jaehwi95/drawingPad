//
//  DrawingPath.swift
//
//
//  Created by Jaehwi Kim on 2024/07/08.
//

import SwiftUI

struct DrawingPath {
    private var segments: [(points: [CGPoint], count: Int)] = []
    private var linePoints: [CGPoint] = []
    private var dotWidth: CGFloat
    
    public init(dotWidth: CGFloat) {
        self.dotWidth = dotWidth
    }
    
    mutating func addDot(_ point: CGPoint) {
        linePoints.append(point)
        segments.append(
            (points: linePoints, count: linePoints.count)
        )
        linePoints.removeAll()
    }
    
    mutating func addLine(_ point: CGPoint) {
        linePoints.append(point)
    }
    
    mutating func endLine() {
        segments.append(
            (points: linePoints, count: linePoints.count)
        )
        linePoints.removeAll()
    }
    
    var path: Path {
        var path = Path()
        
        if !linePoints.isEmpty {
            if let firstPoint = linePoints.first {
                path.move(to: firstPoint)
                linePoints.forEach { point in
                    path.addLine(to: point)
                }
            }
        }
        
        segments.forEach { segment in
            if segment.count == 1 {
                if let firstPoint = segment.points.first {
                    path.move(to: firstPoint)
                    path.addRect(CGRect(x: firstPoint.x, y: firstPoint.y, width: 1, height: 1))
                }
            } else {
                if let firstPoint = segment.points.first {
                    path.move(to: firstPoint)
                    segment.points.forEach { point in
                        path.addLine(to: point)
                    }
                }
            }
        }
        
        return path
    }
}
