//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let PI2 = CGFloat(2*M_PI)

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}

extension CGPoint {
    func distanceTo(_ point: CGPoint) -> CGFloat {
        let x = self.x - point.x
        let y = self.y - point.y
        return sqrt(x*x+y*y)
    }
    
    func angleTo(_ point: CGPoint) -> CGFloat {
        let x = (point.x - self.x)
        let y = -(point.y - self.y) //y is inverted in graphical axis
        var a:CGFloat = 0
        //arc tg isn't a continuous function
        //for some x and y variations, it needs to be added or removed M_PI (180 degrees)
        //for correct angle calculations
         if (x < 0 && y > 0) {
            a = atan(y/x) - CGFloat(M_PI)
        } else if (x < 0 && y < 0) {
            a = atan(y/x) + CGFloat(M_PI)
        } else {
            a = atan(y/x)
        }
        
        while a < 0 {
            a += PI2
        }
        
        while a > PI2 {
            a -= PI2
        }
        
        //print("angle: \(a)")
        
        return a
    }
}


class FVector {
    var point: CGPoint
    var angle: CGFloat
    var d: CGFloat
    var lenght: CGFloat
    
    init(point: CGPoint, origin: CGPoint, end: CGPoint){
        let x = point.x - origin.x
        let y = point.y - origin.y
        
        self.angle = origin.angleTo(point)
        self.d = origin.distanceTo(point)
        self.point = CGPoint(x: x, y: y)
        
        self.lenght = origin.distanceTo(end)
        
    }
    func applyTransform(newOrigin origin:CGPoint, lenght: CGFloat, angle: CGFloat) -> CGPoint {
        
        var a = -(self.angle + angle)
        
        while a < 0 {
            a += PI2
        }
        
        while a > PI2 {
            a -= PI2
        }
        
        
        let scale = lenght / self.lenght
        
        let d = self.d * scale
        
        let newY = d * sin(a) + origin.y
        let newX = d * cos(a) + origin.x
        
        return CGPoint(x: newX, y: newY)
        
    }
}

class PointView: UIView, UIGestureRecognizerDelegate {
    let size = CGSize(width: 12.0, height: 12.0)
    init(center: CGPoint) {
        super.init(frame: CGRect(origin: center, size: size))
        self.backgroundColor = .red
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
        self.superview?.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol FinishMovingDelegate {
    func didFinishMoving()
}

class ConfigurationView: UIView, FinishMovingDelegate {
    
    var mainPoints: [PointView] = []
    
    let margin:CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setNumberOfPoints(_ count: Int) {
        if (count < 2) { return }
        mainPoints.removeAll()
        
        let center = self.center
        
        let begin = self.frame.width * margin
        let end = self.frame.width - begin
        
        let step = (end - begin)/CGFloat(count - 1)
        
        for i in 0..<count {
            let centerX = begin + step * CGFloat(i)
            let view = PointView(center: CGPoint(x: centerX, y: center.y))
            mainPoints.append(view)
            self.addSubview(view)
        }
        
        let point = mainPoints[1]
        setPosition(x: point.center.x, y: point.center.y - 50, forPoint: point)
        
        mainPoints.first!.isUserInteractionEnabled = false
        mainPoints.last!.isUserInteractionEnabled = false
        
        setNeedsDisplay()
        self.superview?.setNeedsDisplay()
    }
    
    func didFinishMoving() {
        (superview as? FinishMovingDelegate)?.didFinishMoving()
    }

    
    override func draw(_ rect: CGRect) {
        
        if (mainPoints.isEmpty) { return }
        
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: mainPoints.first!.center)

        for i in 1..<mainPoints.count {
            bezierPath.addLine(to: mainPoints[i].center)
        }
        
        bezierPath.lineWidth = 2.0
        UIColor.red.set()
        bezierPath.stroke()
        
    }
    
    func setPosition(x: CGFloat, y: CGFloat, forPoint point: PointView) {
        point.center = CGPoint(x: x, y: y)
        self.setNeedsDisplay()
    }
    
    func printTime(label: String = "", start: DispatchTime, end: DispatchTime) {
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let time = nanoTime / 1_000_000
        
        print("time: \(time)  __ \(label.uppercased())")
    }
}

class FractalView: UIView, FinishMovingDelegate {
    
    var configurationView: ConfigurationView!
    
    var shapePoints: [CGPoint] = []
    
    var vectors: [FVector] = []
    
    var iterations = 1

    var radius:CGFloat = 0.6
    
    var pathPoints: [CGPoint] = []
    
    var displayBasePolygon = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var numberOfPoints:Int = 4 {
        didSet {
            setupNumberOfPoints(numberOfPoints)
        }
    }
    
    var polygonSides:Int = 4 {
        didSet {
            setPolygonSideNumber(polygonSides)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurationView = ConfigurationView(frame: CGRect(x: 0, y: 0, width: 400, height: 140))
        configurationView.backgroundColor = UIColor.darkGray
        self.addSubview(configurationView)
        
        shapePoints.append(CGPoint(x: 0, y: 400))
        shapePoints.append(CGPoint(x: 400, y: 400))
        self.clearsContextBeforeDrawing = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNumberOfPoints(_ number: Int) {
        configurationView.setNumberOfPoints(number)
    }
    
    func setPolygonSideNumber(_ number: Int) {
        self.shapePoints.removeAll()
        
        var center = self.center
        center.y += configurationView.frame.height / 2
        
        let r = self.frame.height * self.radius / 2
        
        let pi = CGFloat(M_PI)
        let N = CGFloat(number)
        for i in 0..<number {
            var point = CGPoint()
            let n = CGFloat(i)
            point.x = r * cos(2.0*pi*n/N) + center.x
            point.y = r * sin(2.0*pi*n/N) + center.y
            self.shapePoints.append(point)
        }
        
        reset()
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        if (configurationView == nil) { return }
        
        if (pathPoints.isEmpty) { return }
        
        if (vectors.isEmpty) { return }
        
        if (displayBasePolygon) { showBasicPolygon() }
        
        let path = UIBezierPath()
        path.move(to: pathPoints.first!)
        
        //draw()
        for point in pathPoints {
            path.addLine(to: point)
        }
        
        path.addLine(to: pathPoints.first!)
        
        path.lineWidth = 2.0
        UIColor.yellow.set()
        path.stroke()
    }
    
    func draw() {
        
        DispatchQueue.background(delay: 0.0, background: {
            var bezierPath = UIBezierPath()
            
            for i in 1..<self.shapePoints.count {
                
                let pointA = self.shapePoints[i]
                let pointB = self.shapePoints[i-1]
                
                bezierPath.move(to: pointA)
                
                self.drawPath(pointA: pointA, pointB: pointB, bezierPath: &bezierPath, iteration: 1)
            }
            
            let pointA = self.shapePoints.first!
            
            let pointB = self.shapePoints.last!
            
            bezierPath.move(to: pointA)
            
            self.drawPath(pointA: pointA, pointB: pointB, bezierPath: &bezierPath, iteration: 1)
            
            
            //self.path = bezierPath
            
        }, completion: {
            
            self.setNeedsDisplay()
        })
        
        
    }
    
    func generateVectors() {
        vectors.removeAll()
        let origin = configurationView.mainPoints.first!.center
        let end = configurationView.mainPoints.last!.center
        for i in 1..<configurationView.mainPoints.count-1 {
            let v = FVector(point: configurationView.mainPoints[i].center, origin: origin, end: end)
            self.vectors.append(v)
        }
    }
    
    func drawPath(pointA: CGPoint, pointB: CGPoint, bezierPath: inout UIBezierPath, iteration: Int) {
        if (iteration > self.iterations) { return }
        
        let it = iteration + 1
        
        var subpoints = calculateMidPoints(pointA: pointA, pointB: pointB)
        
        
        for i in 1..<subpoints.count {
            let point = subpoints[i]
            let origin = subpoints[i-1]
            
            drawPath(pointA: origin, pointB: point, bezierPath: &bezierPath, iteration: it)
        }
        
        if (iteration == self.iterations) {
            bezierPath.move(to: pointA)
            for subpoint in subpoints {
                bezierPath.addLine(to: subpoint)
            }
        }
    }
    
    func calculateMidPoints(pointA: CGPoint, pointB: CGPoint) -> [CGPoint] {
        
        let lenght = pointA.distanceTo(pointB)
        let angle = pointA.angleTo(pointB)
        
        var points: [CGPoint] = []
        
        points.append(pointA)
        
        for vector in vectors {
            let p = vector.applyTransform(newOrigin: pointA, lenght: lenght, angle: angle)
            points.append(p)
        }
        
        points.append(pointB)
        
        return points
    }
    
    func showBasicPolygon() {
        let basicPath = UIBezierPath()
        basicPath.move(to: self.shapePoints.first!)
        for point in self.shapePoints {
            basicPath.addLine(to: point)
        }
        basicPath.addLine(to: self.shapePoints.first!)
        UIColor.white.withAlphaComponent(0.3).set()
        basicPath.stroke()
    }
    
    func didFinishMoving() {
        reset()
    }
    
    func reset() {
        self.pathPoints = shapePoints
        
        
        generateVectors()
        
        self.setNeedsDisplay()
        
        let context = UIGraphicsGetCurrentContext()
        context?.clear(self.frame)
    }
}


let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))

fractalView.displayBasePolygon = true

fractalView.numberOfPoints = 10

fractalView.iterations = 2

fractalView.polygonSides = 5

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true
