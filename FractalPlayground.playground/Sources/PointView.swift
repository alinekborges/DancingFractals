import Foundation
import UIKit

public protocol FinishMovingDelegate {
    func didFinishMoving()
    func didChangeMove()
}

public class PointView: UIView, UIGestureRecognizerDelegate {
    let size = CGSize(width: 26.0, height: 26.0)
    let subsize = CGSize(width: 12.0, height: 12.0)
    
    public init(center: CGPoint, color: UIColor) {
        super.init(frame: CGRect(origin: center, size: size))
        self.backgroundColor = .clear
        self.center = center
        
        let subpoint = UIView()
        subpoint.frame.size = self.subsize
        subpoint.center = CGPoint(x: 13.0, y: 13.0)
        subpoint.backgroundColor = color
        subpoint.layer.cornerRadius = subpoint.frame.height/2
        print("subpoint center: \(subpoint.center)")
        self.addSubview(subpoint)
        
        //let gesture = UIPanGestureRecognizer(target: self, action:#selector(self.handleGesture(recognizer:)))
        //self.addGestureRecognizer(gesture)
        
    }
    
    func handleGesture(recognizer:UIPanGestureRecognizer) {
        if (recognizer.state == .ended || recognizer.state == .cancelled) {
            
            print("finish Moving 0")
            (superview as? FinishMovingDelegate)?.didFinishMoving()
        }
        let translation = recognizer.translation(in: self)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self)
        (superview as? FinishMovingDelegate)?.didChangeMove()
        
        self.superview?.setNeedsDisplay()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
