import Foundation
import UIKit


public class ProcessFractal: Operation {
    var TAG: Int
    var pathPoints: [CGPoint] = []
    var iterations: Int = 1
    var vectors: [FVector] = []
    let operationQueue = OperationQueue()
    
    var colors:[UIColor] = []
    
    var lines: [[Line]] = []
    
    init(withTag tag: Int, points: [CGPoint], vectors: [FVector], iterations: Int) {
        self.pathPoints = points
        self.vectors = vectors
        self.iterations = iterations
        self.TAG = tag
        
        self.colors = Colors.generateColors(numberOfColors: Colors.numberOfColors)
    }
    
    override public func main() {
        if self.isCancelled { return }
        
        redraw(points: self.pathPoints)
        
        
        for _ in 0..<iterations {
            if (self.isCancelled) { break }
            self.drawSubpaths()
            redraw(points: self.pathPoints)
        }
    }
    
    func redraw(points: [CGPoint]) {
        //self.update?(self.pathPoints)
        let lines = pathFromPoints(points: points)
        self.lines.append(lines)
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
            self.pathPoints.insert(contentsOf: subpoints, at: i+1)
            
            
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
    
    func pathFromPoints(points: [CGPoint]) -> [Line] {
        let pointsPerColor = (points.count / Colors.numberOfColors) + 1
        var color = 0
        
        var bpath = UIBezierPath()
        bpath.move(to: points[0])
        
        var lines:[Line] = []
        
        for i in 0..<points.count {
            if (self.isCancelled) { break }
            bpath.addLine(to: points[i])
            
            if (i % pointsPerColor == 0) {
                
                let line = Line(path: bpath.copy() as! UIBezierPath,
                                color: colors[color])
                lines.append(line)
                bpath = UIBezierPath()
                
                bpath.move(to: points[i])
                
                color += 1
                if (color >= colors.count) {
                    color = 0
                }
                
            }
        }
        
        
        let line = Line(path: bpath.copy() as! UIBezierPath,
                        color: colors[color])
        lines.append(line)
        
        return lines
    }
}
