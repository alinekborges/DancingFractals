import Foundation
import UIKit

public protocol FinishMovingDelegate {
    func didFinishMoving()
    func didChangeMove()
}

public struct AnimationParams {
    var currentXtime = 0.0
    var currentYtime = 0.0
    
    var directionX = 1
    var directionY = 1
    
    var stepX:CGFloat = 0.0
    var stepY:CGFloat = 0.0
    
    var timeX = 0.0
    var timeY = 0.0
    
    public init() { }
}

public class PointView: UIView {
    let size = CGSize(width: 26.0, height: 26.0)
    let subsize = CGSize(width: 12.0, height: 12.0)
    
    var animationParams = AnimationParams()
    
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
        self.animationParams.stepX = CGFloat(delta) / (CGFloat(time) / CGFloat(Constants.timeInterval))
        
        //it starts in the middle
        self.animationParams.currentXtime = time / 2.0
        self.animationParams.timeX = time
    }
    
    public func animateY(delta: Int, time: Double) {
        self.animationParams.stepY = CGFloat(delta) / (CGFloat(time) / CGFloat(Constants.timeInterval))
        
        //it starts in the middle
        self.animationParams.currentYtime = time / 2.0
        self.animationParams.timeY = time
    }
    
    func move() {
        moveX()
        moveY()
    }
    
    func moveX() {
        self.animationParams.currentXtime += self.timeInterval
        if (self.animationParams.currentXtime > animationParams.timeX) {
            //starts over
            self.animationParams.currentXtime = 0.0
            //invert movement direction
            self.animationParams.directionX *= -1
        }
        
        var newX = self.center.x + self.animationParams.stepX * CGFloat(self.animationParams.directionX)
        
        if (newX >= self.superview!.bounds.width) {
            newX = self.superview!.bounds.width
        } else if newX < 0 {
            newX = 0
        }
        
        self.center.x = newX
    }
    
    func moveY() {
        self.animationParams.currentYtime += self.timeInterval
        if (self.animationParams.currentYtime > animationParams.timeY) {
            //starts over
            self.animationParams.currentYtime = 0.0
            //invert movement direction
            self.animationParams.directionY *= -1
        }
        
        var newY = self.center.y + self.animationParams.stepY * CGFloat(self.animationParams.directionY)
        
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
