import Foundation
import UIKit

public class ProcessBezierPath: Operation {
    var points: [CGPoint] = []
    var bezierPath: UIBezierPath = UIBezierPath()
    var lines: [Line] = []
    var currentColor = 0
    var colors:[UIColor] = []
    
    var t: CGFloat = 0.1
    
    public init(points: [CGPoint]) {
        self.points = points
        self.colors = Colors.generateColors(numberOfColors: Colors.numberOfColors)
    }
    
    override public func main() {
        
        if self.isCancelled {
            return
        }
        
        
        
        if self.points.isEmpty { return }
        
        iterateBetween(i: 0, max: self.points.count)
        
        
        
    }
    
    func iterateBetween(i: Int, max:Int) {
        let start = DispatchTime.now()
        let pointsPerColor = (self.points.count / Colors.numberOfColors) + 1
        var color = currentColor
        
        var bpath = UIBezierPath()
        bpath.move(to: self.points[color])
        
        for i in i..<max {
            if (self.isCancelled) { return }
            bpath.addLine(to: self.points[i])
            
            if (i % pointsPerColor == 0) {
                
                let line = Line(path: bpath.copy() as! UIBezierPath,
                                color: colors[color])
                self.lines.append(line)
                bpath = UIBezierPath()
                
                bpath.move(to: self.points[i])
                
                color += 1
                if (color >= colors.count) {
                    color = 0
                }
                
            }
        }
        
        let line = Line(path: bpath.copy() as! UIBezierPath,
                        color: colors[color])
        self.lines.append(line)
        
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        var timeInterval = Double(nanoTime) / 1_000_000_000
        
        //while (timeInterval < 0.1) {
            //let end = DispatchTime.now()
            //let nano = end.uptimeNanoseconds - start.uptimeNanoseconds
            //timeInterval = Double(nano) / 1_000_000_000
        //}
        
    }
    
}
