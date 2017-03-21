import Foundation
import UIKit


public class ProcessFractal: Operation {
    var TAG: Int
    var pathPoints: [CGPoint] = []
    var iterations: Int = 1
    var vectors: [FVector] = []
    var update: ((_ path: [CGPoint]) -> Void)?
    let operationQueue = OperationQueue()
    
    init(withTag tag: Int, points: [CGPoint], vectors: [FVector], iterations: Int) {
        self.pathPoints = points
        self.vectors = vectors
        self.iterations = iterations
        self.TAG = tag
    }
    
    override public func main() {
        if self.isCancelled { return }
        
        for _ in 0..<iterations {
            if (self.isCancelled) { break }
            
            self.drawSubpaths()
            redraw()
        }
    }
    
    func redraw() {
        self.update?(self.pathPoints)
    }
    
    override public func cancel() {
        super.cancel()
        self.operationQueue.cancelAllOperations()
    }
    
    func drawSubpaths() {
        var i = 0
        while (i < self.pathPoints.count-1) {
            
            let subpoints = self.calculateMidPoints(start: i, end: i+1)
            if (self.isCancelled) { return }
            //if (i+1 <= pathPoints.count+1) {
            self.pathPoints.insert(contentsOf: subpoints, at: i+1)
            //}
            
            i += subpoints.count + 1
        }
    }
    
    func calculateMidPoints(start: Int, end: Int) -> [CGPoint] {
        
        let pointA = self.pathPoints[start]
        let pointB = self.pathPoints[end]
        
        let lenght = pointA.distanceTo(pointB)
        let angle = pointA.angleTo(pointB)
        
        var points: [CGPoint] = []
        
        for vector in vectors {
            if (self.isCancelled) { break }
            let p = vector.applyTransform(newOrigin: pointA, lenght: lenght, angle: angle)
            points.append(p)
        }
        
        return points
    }
    
    func pathFromPoints(points: [CGPoint]) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        if (points.isEmpty) { return bezierPath }
        bezierPath.move(to: points.first!)
        for point in points {
            bezierPath.addLine(to: point)
        }
        return bezierPath
    }
}
