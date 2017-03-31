import Foundation
import UIKit

public protocol FinishMovingDelegate {
    func didFinishMoving()
    func didChangeMove()
}

public class PointView: UIView {
    let size = CGSize(width: 26.0, height: 26.0)
    let subsize = CGSize(width: 12.0, height: 12.0)
    
    var origin: CGPoint = CGPoint()
    var destination: CGPoint = CGPoint()
    
    var currentXtime = 0.0
    var currentYtime = 0.0
    
    var multiplierX = 1
    
    var stepX:CGFloat = 1
    
    let timeInterval = 0.1
    
    public init(center: CGPoint, color: UIColor) {
        super.init(frame: CGRect(origin: center, size: size))
        self.backgroundColor = .clear
        self.center = center
        
        let subpoint = UIView()
        subpoint.frame.size = self.subsize
        subpoint.center = CGPoint(x: 13.0, y: 13.0)
        subpoint.backgroundColor = color
        subpoint.layer.cornerRadius = subpoint.frame.height/2
        self.addSubview(subpoint)
        
    }
    
    func animateX(deltaX: Int, time: Double) {
        self.origin.x = self.center.x - CGFloat(deltaX) / 2.0
        self.destination.x = self.center.x + CGFloat(deltaX) / 2.0
        self.stepX = CGFloat(deltaX) / (CGFloat(time) / CGFloat(timeInterval))
        
        
        //it starts in the middle
        self.currentXtime = time / 2.0
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { (timer) in
            self.currentXtime += self.timeInterval
            if (self.currentXtime > time) {
                //starts over
                self.currentXtime = 0.0
                //invert movement direction
                self.multiplierX *= -1
            }
            
            self.center.x += self.stepX * CGFloat(self.multiplierX)
            self.setNeedsDisplay()
            (self.superview as? FinishMovingDelegate)?.didChangeMove()
        }
    }
    
    func animateY(deltaY: Int, time: Double) {
        self.origin.y = self.center.y - CGFloat(deltaY) / 2.0
        self.destination.y = self.center.y + CGFloat(deltaY) / 2.0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
