import Foundation
import UIKit

public protocol FinishMovingDelegate {
    func didFinishMoving()
    func didChangeMove()
}

public class PointView: UIView {
    let size = CGSize(width: 26.0, height: 26.0)
    let subsize = CGSize(width: 12.0, height: 12.0)
    
    var currentXtime = 0.0
    var currentYtime = 0.0
    
    var directionX = 1
    var directionY = 1
    
    var stepX:CGFloat = 0.0
    var stepY:CGFloat = 0.0
    
    var timeX = 0.0
    var timeY = 0.0
    
    var timeInterval = Constants.timeInterval

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
    
    public func animateX(delta: Int, time: Double) {
        self.stepX = CGFloat(delta) / (CGFloat(time) / CGFloat(Constants.timeInterval))
        
        //it starts in the middle
        self.currentXtime = time / 2.0
        self.timeX = time
    }
    
    public func animateY(delta: Int, time: Double) {
        self.stepY = CGFloat(delta) / (CGFloat(time) / CGFloat(Constants.timeInterval))
        
        //it starts in the middle
        self.currentYtime = time / 2.0
        self.timeY = time
    }
    
    func move() {
        moveX()
        moveY()
    }
    
    func moveX() {
        self.currentXtime += self.timeInterval
        if (self.currentXtime > timeX) {
            //starts over
            self.currentXtime = 0.0
            //invert movement direction
            self.directionX *= -1
        }
        
        var newX = self.center.x + self.stepX * CGFloat(self.directionX)
        
        if (newX >= self.superview!.bounds.width) {
            newX = self.superview!.bounds.width
        } else if newX < 0 {
            newX = 0
        }
        
        self.center.x = newX
    }
    
    func moveY() {
        self.currentYtime += self.timeInterval
        if (self.currentYtime > timeY) {
            //starts over
            self.currentYtime = 0.0
            //invert movement direction
            self.directionY *= -1
        }
        
        var newY = self.center.y + self.stepY * CGFloat(self.directionY)
        
        if (newY >= self.superview!.bounds.height) {
            newY = self.superview!.bounds.height
        } else if newY < 0 {
            newY = 0
        }
        
        self.center.y = newY
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
