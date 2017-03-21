import Foundation
import UIKit

public class PointView: UIView, UIGestureRecognizerDelegate {
    let size = CGSize(width: 12.0, height: 12.0)
    
    public init(center: CGPoint, color: UIColor) {
        super.init(frame: CGRect(origin: center, size: size))
        self.backgroundColor = color
        self.center = center
        self.layer.cornerRadius = self.frame.height/2
        
        let gesture = UIPanGestureRecognizer(target: self, action:#selector(self.handleGesture(recognizer:)))
        self.addGestureRecognizer(gesture)
        
    }
    
    func handleGesture(recognizer:UIPanGestureRecognizer) {
        if (recognizer.state == .ended || recognizer.state == .cancelled) {
            (superview as? FinishMovingDelegate)?.didFinishMoving()
        }
        let translation = recognizer.translation(in: self)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self)
        (superview as? FinishMovingDelegate)?.didFinishMoving()
        self.superview?.setNeedsDisplay()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
