import Foundation
import UIKit



public class ConfigurationView: UIView, FinishMovingDelegate {
    
    var mainPoints: [PointView] = []
    
    var margin:CGFloat = 0.25
    
    var movingPoint: PointView?
    
    var colors: [UIColor] = []
    
    var iterationsView: IterationsView?
    
    var pointsCount: Int = 3
    
    var isAnimateIterations: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0.02, alpha: 0.7)
        
        iterationsView = IterationsView()
        self.iterationsView?.frame = CGRect(origin: CGPoint(x: 0, y: 10.0), size: CGSize(width: self.frame.width, height: 30.0))
        iterationsView?.setupButtons()
        
        self.frame = self.frame.insetBy(dx: -2.0, dy: -2.0);
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        
        self.addSubview(iterationsView!)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        for point in self.mainPoints {
            if (point.frame.contains(location)) {
                point.center = location
                self.movingPoint = point
                self.setNeedsDisplay()
                break
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (movingPoint != nil) {
            let touch: UITouch = touches.first! as UITouch
            let location: CGPoint = touch.location(in: self)
            
            if (self.frame.contains(location)) {
                self.movingPoint?.center = location
                
                didChangeMove()
                self.setNeedsDisplay()
            }
        
            
        }
        
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (movingPoint != nil) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        self.movingPoint?.center = location
        self.movingPoint = nil
        
        didFinishMoving()
        self.setNeedsDisplay()
        }
    }
    
    func animateIterations() {
        isAnimateIterations = true
        
        self.isUserInteractionEnabled = false
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            self.iterationsView?.selectNextIteration()
        }
    }
    
    func redrawPoints() {
        setNumberOfPoints(self.pointsCount)
    }
    
    func setNumberOfPoints(_ count: Int) {
        
        if (count < 2) { return }
        
        self.pointsCount = count
        
        for p in mainPoints {
            p.removeFromSuperview()
        }
        
        mainPoints.removeAll()
        
        let begin = self.frame.width * margin
        let end = self.frame.width - begin
        
        let step = (end - begin)/CGFloat(count - 1)
        
        colors = Colors.generateColors(numberOfColors: count + count - 1)
        
        for i in 0..<count {
            let centerX = begin + step * CGFloat(i)
            let centerY:CGFloat = self.center.y + ( 30.0 + self.iterationsView!.frame.height ) / 2.0
            let view = PointView(center: CGPoint(x: centerX, y: centerY), color: colors[i*2])
            mainPoints.append(view)
            self.addSubview(view)
        }
        
        //if main points is even
        if (mainPoints.count % 2 == 0) {
            let lower = mainPoints.count / 2
            print(lower)
            let top = lower + 1
            print(top)
            mainPoints[lower-1].center.y -= 55
            mainPoints[top-1].center.y -= 55
        } else {
            let top = mainPoints.count / 2
            mainPoints[top].center.y -= 55
        }
    
        setNeedsDisplay()
        self.superview?.setNeedsDisplay()
    }
    
    public func didFinishMoving() {
        (superview as? FinishMovingDelegate)?.didFinishMoving()
    }
    
    public func didChangeMove() {
        (superview as? FinishMovingDelegate)?.didChangeMove()
    }
    
    override public func draw(_ rect: CGRect) {
        
        if (mainPoints.isEmpty) { return }
        
        for i in 1..<mainPoints.count {
            let bezierPath = UIBezierPath()
            bezierPath.move(to: mainPoints[i-1].center)
            bezierPath.addLine(to: mainPoints[i].center)
            bezierPath.lineWidth = 2.0
            colors[i*2 - 1].set()
            bezierPath.stroke()
        }
    }
    
    func setPosition(x: CGFloat, y: CGFloat, forPoint point: PointView) {
        point.center = CGPoint(x: x, y: y)
        self.setNeedsDisplay()
    }
    
    func setOrientation(orientation: UIInterfaceOrientation) {
        
        self.iterationsView?.frame = CGRect(origin: CGPoint(x: 0, y: 10.0), size: CGSize(width: self.frame.width, height: 30.0))
        
        if orientation == .portrait {
            self.margin = 0.25
        } else {
            self.margin = 0.08
        }
        
        self.redrawPoints()
        
        iterationsView?.setNeedsLayout()
        iterationsView?.setupButtons()
        
    }
    
    
    
}
