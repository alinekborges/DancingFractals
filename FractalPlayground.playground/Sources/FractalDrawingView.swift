import Foundation
import UIKit

//View responsable for drawing the fractal on the screen with related color
public class FractalDrawingView: UIView {
    var lines: [[Line]] = [[]]
    
    var newLines: [Line] = []
    
    var iteration: Int = 0
    
    var points: [CGPoint] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func draw(animated: Bool = false) {
     
        if (lines.isEmpty) { return }
        
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        if (iteration >= lines.count) {
            iteration = lines.count - 1
        }
        
        let newLines = lines[iteration]
        
        for i in 0..<newLines.count {
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.path = newLines[i].path.cgPath
            shapeLayer.strokeColor = newLines[i].color.cgColor
            shapeLayer.lineWidth = 1.0
            shapeLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(shapeLayer)
            
        }
        
        self.setNeedsDisplay()
        
    }
}
