//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let PI2 = CGFloat(2*M_PI)

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
        
        //mainPoints.first!.isUserInteractionEnabled = false
        //mainPoints.last!.isUserInteractionEnabled = false
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.backgroundColor = .yellow
        
        button.addTarget(self, action: #selector(self.redraw(view:)), for: .touchUpInside)
        self.addSubview(button)
        
        setNeedsDisplay()
        self.superview?.setNeedsDisplay()
    }
    
    func didFinishMoving() {
        (superview as? FinishMovingDelegate)?.didFinishMoving()
    }

    func redraw(view: AnyObject?) {
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

class ProcessBezierPath: Operation {
    var points: [CGPoint] = []
    var bezierPath: UIBezierPath = UIBezierPath()
    
    init(points: [CGPoint]) {
        self.points = points
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        if self.points.isEmpty { return }
        
        bezierPath.move(to: self.points.first!)
        for point in self.points {
            bezierPath.addLine(to: point)
        }
    }
}

class ProcessFractal: Operation {
    var TAG: Int
    var pathPoints: [CGPoint] = []
    var iterations: Int = 1
    var vectors: [FVector] = []
    var update: ((_ path: [CGPoint]) -> Void)?
    let operationQueue = OperationQueue()
    
    init(withTag tag: Int, points: [CGPoint], vectors: [FVector], iterations: Int) {
        self.pathPoints = points
        self.vectors = vectors
        self.iterations = iterations
        self.TAG = tag
    }
    
    override func main() {
        if self.isCancelled { return }
        
        for _ in 0..<iterations {
            if (self.isCancelled) { break }
            
            self.drawSubpaths()
        }
    }
    
    func redraw() {
        self.update?(self.pathPoints)
    }
    
    override func cancel() {
        super.cancel()
        self.operationQueue.cancelAllOperations()
    }
    
    func drawSubpaths() {
        var i = 0
        while (i < self.pathPoints.count-1) {
            
            let subpoints = self.calculateMidPoints(start: i, end: i+1)
            if (self.isCancelled) { print("cancelling subpaths"); return }
            if (i+1 <= pathPoints.count+1) {
                self.pathPoints.insert(contentsOf: subpoints, at: i+1)
            }
            redraw()
            i += subpoints.count + 1
        }
    }
    
    func calculateMidPoints(start: Int, end: Int) -> [CGPoint] {
        
        let pointA = self.pathPoints[start]
        let pointB = self.pathPoints[end]
        
        let lenght = pointA.distanceTo(pointB)
        let angle = pointA.angleTo(pointB)
        
        var points: [CGPoint] = []
        
        for vector in vectors {
            if (self.isCancelled) { print("cancelling mid points"); break }
            let p = vector.applyTransform(newOrigin: pointA, lenght: lenght, angle: angle)
            points.append(p)
        }
        
        return points
    }
    
    func pathFromPoints(points: [CGPoint]) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        if (points.isEmpty) { return bezierPath }
        bezierPath.move(to: points.first!)
        for point in points {
            bezierPath.addLine(to: point)
        }
        return bezierPath
    }
}

class FractalView: UIView, FinishMovingDelegate {
    
    var configurationView: ConfigurationView!
    
    var shapePoints: [CGPoint] = []
    
    var bezierPath = UIBezierPath()
    
    var vectors: [FVector] = []
    
    var iterations = 1

    var radius:CGFloat = 0.6
    
    var pathPoints: [CGPoint] = []
    
    var runningCalculations = false
    
    var runCount: Int = 0
    
    var backgroundOperation: ProcessFractal?
    
    var bezierPathOperation: ProcessBezierPath = ProcessBezierPath(points: [])
    
    let operationQueue = OperationQueue()
    
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
        
        shapePoints.append(shapePoints.first!)
        
        reset()
        
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        if (displayBasePolygon) { showBasicPolygon() }
        
        let context = UIGraphicsGetCurrentContext()
        context?.clear(self.frame)
        
        UIColor.yellow.set()
        
        bezierPath.stroke()
        
    }
    
    func draw() {
        
        let operation = ProcessFractal(withTag: self.runCount, points: self.pathPoints, vectors: self.vectors, iterations: self.iterations)
        
        operation.update = {(path) in
            DispatchQueue.main.async {
                if (operation.TAG == self.runCount) {
                    //self.bezierPath = path
                    //self.setNeedsDisplay()
                    self.startBezierCalculation(points: path)
                }
            }
        }
        
        operation.completionBlock = {
            DispatchQueue.main.async {
                print("finished operations")
                self.setNeedsDisplay()
            }
        }

        operation.qualityOfService = .background
        
        self.backgroundOperation = operation
        
        operationQueue.addOperation(operation)
        
    }
    
    func startBezierCalculation(points: [CGPoint]) {
        if (!self.bezierPathOperation.isExecuting) {
            let operation = ProcessBezierPath(points: points)
            operation.completionBlock = {
                DispatchQueue.main.async {
                    self.bezierPath = operation.bezierPath
                    self.setNeedsDisplay()
                }
            }
            
            operationQueue.addOperation(operation)
        }
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
    
    
    func showBasicPolygon() {
        let basicPath = UIBezierPath()
        basicPath.move(to: self.shapePoints.first!)
        for point in self.shapePoints {
            basicPath.addLine(to: point)
        }
        UIColor.white.withAlphaComponent(0.3).set()
        basicPath.stroke()
    }
    
    func didFinishMoving() {
        reset()
    }
    
    func reset() {
        
        self.runCount += 1
        
        backgroundOperation?.cancel()
        
        self.pathPoints = shapePoints
        generateVectors()
        
        draw()
        
        self.bezierPath = UIBezierPath()
        
        print("starting a new drawing")
    
    }
}


let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))

fractalView.displayBasePolygon = false

fractalView.numberOfPoints = 5

fractalView.iterations = 3

fractalView.polygonSides = 5

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true
