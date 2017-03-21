import Foundation
import UIKit

public class FractalView: UIView, FinishMovingDelegate {
    
    var configurationView: ConfigurationView!
    var fractalDrawingView: FractalDrawingView!
    
    var shapePoints: [CGPoint] = []
    
    var bezierPath = UIBezierPath()
    
    var vectors: [FVector] = []
    
    public var iterations = 1
    
    public var radius:CGFloat = 0.6
    
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
        super.init(frame: frame)
        
        configurationView = ConfigurationView(frame: CGRect(x: 0, y: 0, width: 400, height: 140))
        self.addSubview(configurationView)
        
        fractalDrawingView = FractalDrawingView(frame: CGRect(x: 0, y: configurationView.frame.height, width: frame.width, height: frame.height - configurationView.frame.height))
        self.addSubview(fractalDrawingView)
        
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
                print("finish drawing")
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
                    self.fractalDrawingView.lines.append(operation.lines)
                    //self.fractalDrawingView.setNeedsDisplay()
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
    
    public func didFinishMoving() {
        reset()
    }
    
    public func reset() {
        
        self.runCount += 1
        
        backgroundOperation?.cancel()
        fractalDrawingView.lines.removeAll()
        
        self.pathPoints = shapePoints
        generateVectors()
        
        draw()
        
        self.bezierPath = UIBezierPath()
        
        print("starting a new drawing")
        
    }
}
