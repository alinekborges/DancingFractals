//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let PI2 = CGFloat(2*M_PI)


//https://github.com/raywenderlich/SKTUtils/blob/master/SKTUtils/CGVector%2BExtensions.swift
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

class FractalView: UIView {
    
    var mainPoints: [PointView] = []
    var vectors: [FVector] = []
    
    let margin:CGFloat = 0.14
    
    var iterations = 1
    
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
        setNeedsDisplay()
    }
    
    func generateVectors() {
        vectors.removeAll()
        let origin = self.mainPoints.first!.center
        let end = self.mainPoints.last!.center
        for i in 1..<mainPoints.count-1 {
            let v = FVector(point: mainPoints[i].center, origin: origin, end: end)
            self.vectors.append(v)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if (mainPoints.isEmpty) { return }
        
        generateVectors()
        
        if (vectors.isEmpty) { return }
        
        var bezierPath = UIBezierPath()
        
        bezierPath.move(to: mainPoints.first!.center)
        let pointA = mainPoints.first!.center
        let pointB = mainPoints.last!.center
        
        
        let start = DispatchTime.now()
        drawPath(pointA: pointA, pointB: pointB, bezierPath: &bezierPath, iteration: 1)
        
        let end = DispatchTime.now()
        bezierPath.lineWidth = 2.0
        UIColor.red.set()
        bezierPath.stroke()
        
        printTime(label: "total", start: start, end: end)
    }
    
    func drawPath(pointA: CGPoint, pointB: CGPoint, bezierPath: inout UIBezierPath, iteration: Int) {
        if (iteration > self.iterations) { return }
        
        let it = iteration + 1
        
        let start = DispatchTime.now()
        var subpoints = calculateMidPoints(pointA: pointA, pointB: pointB)
        let end = DispatchTime.now()
        
        printTime(label: "midpoint", start: start, end: end)
        
        
        for i in 1..<subpoints.count {
            let point = subpoints[i]
            let origin = subpoints[i-1]
            
            drawPath(pointA: origin, pointB: point, bezierPath: &bezierPath, iteration: it)
        }
        
        if (iteration == self.iterations) {
        
            bezierPath.move(to: pointA)
            //print(subpoints)
            subpoints.removeFirst()
            for subpoint in subpoints {
                bezierPath.addLine(to: subpoint)
            }
        
            bezierPath.addLine(to: pointB)
            //bezierPath.append(path)
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

let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

fractalView.setNumberOfPoints(3)

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true
