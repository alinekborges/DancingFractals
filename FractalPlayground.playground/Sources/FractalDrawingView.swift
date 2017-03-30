import Foundation
import UIKit

public class FractalDrawingView: UIView {
    var lines: [[Line]] = [[]]
    
    var oldLines: [Line] = []
    var newLines: [Line] = []
    
    var iteration: Int = 0
    
    var points: [CGPoint] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateBetween(oldPath: UIBezierPath, newPath: UIBezierPath) -> CABasicAnimation {
        let myAnimation = CABasicAnimation(keyPath: "path")
        
        myAnimation.fromValue = oldPath.cgPath
        myAnimation.toValue = newPath.cgPath
        
        
        
        myAnimation.duration = 1.0
        myAnimation.fillMode = kCAFillModeForwards
        myAnimation.isRemovedOnCompletion = false
        
        return myAnimation
        
        //self.layer.mask.addAnimation(myAnimation, forKey: "animatePath")
    }
    
    public func draw(animated: Bool = false) {
     
        if (lines.isEmpty) { return }
        
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        //print("lines count: \(lines.count)")
        //print("iteration: \(iteration)")
        
        if (iteration >= lines.count) {
            iteration = lines.count - 1
        }
        
        let newLines = lines[iteration]
        
        for i in 0..<newLines.count {
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.path = newLines[i].path.cgPath
            shapeLayer.strokeColor = newLines[i].color.cgColor
            shapeLayer.lineWidth = 2.0
            shapeLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(shapeLayer)
            
            if (animated && newLines.count == oldLines.count) {
                let animation = animateBetween(oldPath: oldLines[i].path, newPath: newLines[i].path)
                shapeLayer.add(animation, forKey: "\(i)")
            }
            
        }
        
        oldLines = newLines
        
        self.setNeedsDisplay()
        
    }
}
