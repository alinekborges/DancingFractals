import Foundation
import UIKit

public class FractalView: UIView, FinishMovingDelegate, IterationsDelegate {
    
    var configurationView: ConfigurationView!
    var fractalDrawingView: FractalDrawingView!
    
    var shapePoints: [CGPoint] = []
    
    var vectors: [FVector] = []
    
    public var radius:CGFloat = 0.6
    
    //var pathPoints: [CGPoint] = []
    
    var runningCalculations = false
    
    var runCount: Int = 0
    
    var iteration: Int = Constants.initialIterations
    
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
    
    public var numberOfPoints:Int = 4 {
        didSet {
            setupNumberOfPoints(numberOfPoints)
        }
    }
    
    public var polygonSides:Int = 4 {
        didSet {
            setPolygonSideNumber(polygonSides)
        }
    }
    
    override public init(frame: CGRect) {
        //let frame = UIScreen.main.bounds
        super.init(frame: frame)
        configurationView = ConfigurationView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        
        fractalDrawingView = FractalDrawingView(frame: CGRect(x: 0, y: frame.height*0.3, width: frame.width, height: frame.height*0.7))
        
        configurationView.iterationsView?.delegate = self
        
        self.addSubview(fractalDrawingView)
        self.addSubview(configurationView)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
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
        
    }
    
    func firstDraw() {
        let points = self.shapePoints
        
        fractalDrawingView.iteration = iteration
        
        //print("pathpoints to FIRST draw: \(self.shapePoints.count)")
        
        let operation = ProcessFractal(withTag: self.runCount, points: points, vectors: self.vectors, iterations: iteration)
        
        operation.completionBlock = {
            DispatchQueue.main.async {
                self.fractalDrawingView.lines.append(contentsOf: operation.lines)
                self.fractalDrawingView.points = operation.pathPoints
                self.fractalDrawingView.iteration = self.iteration
                self.draw(isMoving: false)
                self.fractalDrawingView.setNeedsDisplay()
            }
        }
        
        self.backgroundOperation = operation
        
        operationQueue.addOperation(operation)
    }
    
    func draw(isMoving: Bool) {
        
        var iterations = self.iteration
        var points = self.shapePoints
        
        if (isMoving && iterations > Constants.movingIterations ) {
            iterations = Constants.movingIterations
        } else if (isMoving == false) {
            iterations = Constants.maxIterations - self.fractalDrawingView.lines.count
            points = self.fractalDrawingView.points
        }
        
        //print("iteration to draw: \(iterations)")
        fractalDrawingView.iteration = iteration
    
        let operation = ProcessFractal(withTag: self.runCount, points: points, vectors: self.vectors, iterations: iterations)
        
        operation.completionBlock = {
            DispatchQueue.main.async {
                if (isMoving) {
                    self.fractalDrawingView.lines = operation.lines
                    self.fractalDrawingView.points = operation.pathPoints
                    self.fractalDrawingView.setNeedsDisplay()
                } else {
                    operation.lines.removeFirst()
                    self.fractalDrawingView.lines.append(contentsOf: operation.lines)
                    self.fractalDrawingView.points = operation.pathPoints
                    self.fractalDrawingView.iteration = self.iteration
                    self.fractalDrawingView.setNeedsDisplay()
                    print("fractal view completed all iterations -- line count: \(self.fractalDrawingView.lines.count)")
                }
            }
        }
        
        operation.qualityOfService = .background
        
        self.backgroundOperation = operation
        
        operationQueue.addOperation(operation)
        
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
    
    public func didFinishMoving() {
        print("finish Moving 2")
        draw(isMoving: false)
    }
    
    public func didChangeMove() {
        reset(isMoving: true)
    }
    
    public func didSetIteration(_ iteration: Int) {
        self.iteration = iteration
        fractalDrawingView.iteration = iteration
        fractalDrawingView.setNeedsDisplay()
    }
    
    public func start() {
        generateVectors()
        firstDraw()
    }
    
    public func reset(isMoving: Bool) {
        
        self.runCount += 1
        
        backgroundOperation?.cancel()
        fractalDrawingView.lines.removeAll()
        
        //self.pathPoints = shapePoints
        generateVectors()
        
        draw(isMoving: isMoving)
        
    }
    
    
}
