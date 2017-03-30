import Foundation
import UIKit

public class FractalView: UIView, FinishMovingDelegate, IterationsDelegate {
    
    public var radius:CGFloat = 0.6
    
    public var numberOfPoints:Int = 4
    
    public var polygonSides:Int = 4
    
    var configurationView: ConfigurationView!
    var fractalDrawingView: FractalDrawingView!
    
    var orientation: UIInterfaceOrientation! {
        didSet {
            setupOrientation(orientation: orientation)
        }
    }
    
    var shapePoints: [CGPoint] = []
    
    var vectors: [FVector] = []
    
    var runningCalculations = false
    
    var runCount: Int = 0
    
    var iteration: Int = Constants.initialIterations
    
    var backgroundOperation: ProcessFractal?
    
    var bezierPathOperation: ProcessBezierPath = ProcessBezierPath(points: [])
    
    let operationQueue = OperationQueue()
    
    var lines: [Line] = []
    var oldLines: [Line] = []
    
    override public var bounds: CGRect {
        didSet {
            setOrientationFromBounds(bounds: bounds)
        }
    }
    
    var displayBasePolygon = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    
    override public init(frame: CGRect) {
        let frame = UIScreen.main.bounds
        super.init(frame: frame)
        configurationView = ConfigurationView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        
        fractalDrawingView = FractalDrawingView(frame: CGRect(x: 0, y: frame.height*0.3, width: frame.width, height: frame.height*0.7))
        
        configurationView.iterationsView?.delegate = self
        
        self.addSubview(fractalDrawingView)
        self.addSubview(configurationView)
        
        setOrientationFromBounds(bounds: self.bounds)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNumberOfPoints(_ number: Int) {
        configurationView.setNumberOfPoints(number)
    }
    
    func setPolygonSideNumber(_ number: Int) {
        
        print("polygon calcularion:::::::::::: \(number)")
        self.shapePoints.removeAll()
        
        var center = fractalDrawingView.center
        
        if (self.orientation == .portrait) {
            center.y /= 2.0
        } else {
            center.x /= 2.0
        }
        
        let r = self.fractalDrawingView.frame.height * self.radius / 2
        
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
        
    }
    
    func firstDraw() {
        let points = self.shapePoints
        
        fractalDrawingView.iteration = iteration
        
        let operation = ProcessFractal(withTag: self.runCount, points: points, vectors: self.vectors, iterations: Constants.maxIterations)
        
        operation.completionBlock = {
            DispatchQueue.main.async {
                self.fractalDrawingView.lines.append(contentsOf: operation.lines)
                self.fractalDrawingView.points = operation.pathPoints
                self.fractalDrawingView.iteration = self.iteration
                self.fractalDrawingView.draw()
                print("hey first draw")
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
        
        fractalDrawingView.iteration = iteration
    
        self.runCount += 1
        let operation = ProcessFractal(withTag: self.runCount, points: points, vectors: self.vectors, iterations: iterations)
        
        
        operation.completionBlock = {
            DispatchQueue.main.async {
                if (operation.TAG != self.runCount) { return }
                if (isMoving) {
                    self.fractalDrawingView.lines = operation.lines
                    self.fractalDrawingView.points = operation.pathPoints
                    self.fractalDrawingView.draw()
                } else {
                    operation.lines.removeFirst()
                    self.fractalDrawingView.lines.append(contentsOf: operation.lines)
                    self.fractalDrawingView.points = operation.pathPoints
                    self.fractalDrawingView.iteration = self.iteration
                    self.fractalDrawingView.draw()
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
        fractalDrawingView.draw(animated: false)
    }
    
    public func start() {
        backgroundOperation?.cancel()
        fractalDrawingView.lines.removeAll()
        setupNumberOfPoints(numberOfPoints)
        setPolygonSideNumber(polygonSides)
        
        generateVectors()
        firstDraw()
        
    }
    
    public func reset(isMoving: Bool) {
        
        fractalDrawingView.lines.removeAll()
        
        generateVectors()
        
        draw(isMoving: isMoving)
        
    }
    
    private func setupOrientation(orientation: UIInterfaceOrientation) {
        
        if (orientation == .portrait) {
            self.configurationView.frame =  CGRect(x: 0, y: 0, width: self.frame.width , height: self.frame.height * 0.28)
            
            self.fractalDrawingView.frame = CGRect(
                origin: CGPoint(
                    x: 0,
                    y: self.configurationView.frame.height),
                size: CGSize(
                    width: self.frame.width,
                    height: self.frame.height -
                        self.configurationView.frame.height))
            
        } else {
            self.configurationView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.width * 0.35, height: self.frame.height))
            
            self.fractalDrawingView.frame = CGRect(
                origin: CGPoint(
                    x: self.configurationView.frame.width,
                    y: 0),
                size: CGSize(
                    width: self.frame.width - self.configurationView.frame.width,
                    height: self.frame.height))
            
            
        }
        
        self.configurationView.setOrientation(orientation: orientation)
        self.setNeedsLayout()
        
        if (runCount > 0) {
            self.start()
        }
        
    }
    
    private func setOrientationFromBounds(bounds: CGRect) {
        if bounds.width > bounds.height {
            self.orientation = UIInterfaceOrientation.landscapeLeft
        } else {
            self.orientation = UIInterfaceOrientation.portrait
        }
    }
    
    
}
