import Foundation
import UIKit

public class FractalDrawingView: UIView {
    var lines: [[Line]] = [[]]
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        
        //if (displayBasePolygon) { showBasicPolygon() }
        
        let context = UIGraphicsGetCurrentContext()
        context?.clear(self.frame)
        
        
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        for lines in self.lines {
            for line in lines {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = line.path.cgPath
            shapeLayer.strokeColor = line.color.cgColor
            shapeLayer.lineWidth = 1.0
            shapeLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(shapeLayer)
            }
        }
        
    }
}
