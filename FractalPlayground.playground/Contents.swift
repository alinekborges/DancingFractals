//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let PI2 = CGFloat(2*M_PI)

func getColor(hue: CGFloat) -> UIColor {
    return UIColor(hue: hue, saturation: 0.5, brightness: 0.8, alpha: 1.0)
}

func setupColors(numberOfColors: Int) -> [UIColor] {
    let colorStep:CGFloat = 1.0 / CGFloat(numberOfColors)
    var t = colorStep
    var colors:[UIColor] = []
    
    for _ in 0..<numberOfColors {
        t += colorStep
        if t > 1 {
            t = 0
        }
        
        colors.append(getColor(hue: t))
    }
    
    return colors
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
    init(center: CGPoint, color: UIColor) {
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
    
    var colors: [UIColor] = []
    
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
        
        colors = setupColors(numberOfColors: count + count - 1)
        
        for i in 0..<count {
            let centerX = begin + step * CGFloat(i)
            let view = PointView(center: CGPoint(x: centerX, y: center.y), color: colors[i*2])
            mainPoints.append(view)
            self.addSubview(view)
        }
        
        //let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        //button.backgroundColor = .yellow
        
        //button.addTarget(self, action: #selector(self.redraw(view:)), for: .touchUpInside)
        //self.addSubview(button)
        
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
    
    
    
}

struct Line {
    var path: UIBezierPath
    var color: UIColor
}

let numberOfColors = 10
var colors: [UIColor] = []



class ProcessBezierPath: Operation {
    var points: [CGPoint] = []
    var bezierPath: UIBezierPath = UIBezierPath()
    var lines: [Line] = []
    var currentColor = 0
    
    var t: CGFloat = 0.1
    
    init(points: [CGPoint]) {
        self.points = points
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        
        
        if self.points.isEmpty { return }
        
        iterateBetween(i: 0, max: self.points.count)
        
        
        
    }
    
    func iterateBetween(i: Int, max:Int) {
        let start = DispatchTime.now()
        let pointsPerColor = (self.points.count / numberOfColors) + 1
        var color = currentColor
        
        var bpath = UIBezierPath()
        bpath.move(to: self.points[color])
        
        for i in i..<max {
            if (self.isCancelled) { return }
            bpath.addLine(to: self.points[i])
            
            if (i % pointsPerColor == 0) {
                
                let line = Line(path: bpath.copy() as! UIBezierPath,
                                color: colors[color])
                self.lines.append(line)
                bpath = UIBezierPath()
                
                bpath.move(to: self.points[i])
                
                color += 1
                if (color >= numberOfColors) {
                    color = 0
                }
                
            }
        }
        
        let line = Line(path: bpath.copy() as! UIBezierPath,
                        color: colors[color])
        self.lines.append(line)
        
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        var timeInterval = Double(nanoTime) / 1_000_000_000
        
        while (timeInterval < 0.25) {
            let end = DispatchTime.now()
            let nano = end.uptimeNanoseconds - start.uptimeNanoseconds
            timeInterval = Double(nano) / 1_000_000_000
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
            if (self.isCancelled) { return }
            //if (i+1 <= pathPoints.count+1) {
            self.pathPoints.insert(contentsOf: subpoints, at: i+1)
            //}
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
            if (self.isCancelled) { break }
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

class FractalDrawingView: UIView {
    var lines: [Line] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        //if (displayBasePolygon) { showBasicPolygon() }
        
        let context = UIGraphicsGetCurrentContext()
        context?.clear(self.frame)
        
        
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        for line in self.lines {
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = line.path.cgPath
            shapeLayer.strokeColor = line.color.cgColor
            shapeLayer.lineWidth = 1.0
            shapeLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(shapeLayer)
        }
        
    }
}

class FractalView: UIView, FinishMovingDelegate {
    
    var configurationView: ConfigurationView!
    var fractalDrawingView: FractalDrawingView!
    
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
    
    var lines: [Line] = []
    var oldLines: [Line] = []
    
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
        self.addSubview(configurationView)
        
        fractalDrawingView = FractalDrawingView(frame: CGRect(x: 0, y: configurationView.frame.height, width: frame.width, height: frame.height - configurationView.frame.height))
        self.addSubview(fractalDrawingView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNumberOfPoints(_ number: Int) {
        configurationView.setNumberOfPoints(number)
    }
    
    func setPolygonSideNumber(_ number: Int) {
        self.shapePoints.removeAll()
        
        let center = fractalDrawingView.center
        //center.y += configurationView.frame.height / 2
        
        let r = self.frame.height * self.radius / 2
        
        let pi = CGFloat(M_PI)
        let N = CGFloat(number)
        for i in 0..<number {
            var point = CGPoint()
            let n = CGFloat(i)
            point.x = r * cos(2.0*pi*n/N) + center.x
            point.y = r * sin(2.0*pi*n/N) + center.y / 2.0
            self.shapePoints.append(point)
        }
        
        shapePoints.append(shapePoints.first!)
        
        reset()
        
        self.setNeedsDisplay()
    }
    
    
    
    func draw() {
        
        let operation = ProcessFractal(withTag: self.runCount, points: self.pathPoints, vectors: self.vectors, iterations: self.iterations)
        
        operation.update = {(path) in
            DispatchQueue.main.async {
                if (operation.TAG == self.runCount) {
                    self.startBezierCalculation(points: path)
                }
            }
        }
        
        operation.completionBlock = {
            DispatchQueue.main.async {
                self.bezierPathOperation.cancel()
                self.startBezierCalculation(points: operation.pathPoints)
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
                    //self.lines = operation.lines
                    //self.setNeedsDisplay()
                    self.fractalDrawingView.lines = operation.lines
                    self.fractalDrawingView.setNeedsDisplay()
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


colors = setupColors(numberOfColors: numberOfColors)

let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))

fractalView.numberOfPoints = 7

fractalView.iterations = 3

fractalView.polygonSides = 3

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true
