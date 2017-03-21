import Foundation
import UIKit

public class FractalDrawingView: UIView {
    var lines: [[Line]] = [[]]
    
    var oldLines: [Line] = []
    var newLines: [Line] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func draw() {
        
        self.setNeedsDisplay()
        
    }
    
    func animateBetween(oldPath: UIBezierPath, newPath: UIBezierPath) -> CABasicAnimation {
        let myAnimation = CABasicAnimation(keyPath: "path")
        
        myAnimation.fromValue = oldPath
        myAnimation.toValue = newPath
        
        myAnimation.duration = 1.0
        myAnimation.fillMode = kCAFillModeForwards
        myAnimation.isRemovedOnCompletion = false
        
        return myAnimation
        
        //self.layer.mask.addAnimation(myAnimation, forKey: "animatePath")
    }
    
    override public func draw(_ rect: CGRect) {
        
        //if (displayBasePolygon) { showBasicPolygon() }
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.clear(self.frame)
        
        //print("Draw Fractal: \(lines.count)")
        
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
     
        /*for lines in self.lines {
            for line in lines {
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = line.path.cgPath
                shapeLayer.strokeColor = line.color.cgColor
                shapeLayer.lineWidth = 1.0
                shapeLayer.fillColor = UIColor.clear.cgColor
                self.layer.addSublayer(shapeLayer)
            }
        }*/
        
        if (lines.isEmpty) { return }
        
        let oldLines = lines[0]
        
        let newLines = lines.last!
        
        for i in 0..<newLines.count {
            let shapeLayer = CAShapeLayer()
            //let animation = animateBetween(oldPath: oldLines[i].path, newPath: newLines[i].path)
            shapeLayer.path = newLines[i].path.cgPath
            shapeLayer.strokeColor = newLines[i].color.withAlphaComponent(1.0).cgColor
            shapeLayer.lineWidth = 1.0
            shapeLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(shapeLayer)
            
            //shapeLayer.add(animation, forKey: "path")
            
        }
        
        self.setNeedsDisplay()
        
    }
}
