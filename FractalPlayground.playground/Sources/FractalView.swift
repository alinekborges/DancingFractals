import Foundation
import UIKit

/* 
 Main view that has all the logic to make the fractal work
 */
public class FractalView: UIView, FinishMovingDelegate, IterationsDelegate {
    
    //*************************
    //Variables accessible by Playground Code
    public var radius:CGFloat = 0.6
    
    public var numberOfPoints:Int = 4
    
    public var polygonSides:Int = 4
    
    //*************************
    
    //Subviews
    public var configurationView: ConfigurationView!
    var fractalDrawingView: FractalDrawingView!
    
    
    var shapePoints: [CGPoint] = [] //main points of polygons
    
    var vectors: [FVector] = [] //vectors representing top points
    
    var runCount: Int = 0
    
    public var iteration: Int = Constants.initialIterations
    
    var backgroundOperation: ProcessFractal? //Thread that calculates fractal
    
    let operationQueue = OperationQueue() // Queue for background operations
    
    var lines: [Line] = []
    
    
    //*************************
    //Watch for orientation and bounds change to redwaw screen
    override public var bounds: CGRect {
        didSet {
            setOrientationFromBounds(bounds: bounds)
        }
    }
    
    var orientation: UIInterfaceOrientation! {
        didSet {
            setupOrientation(orientation: orientation)
        }
    }
    
    override public var backgroundColor: UIColor? {
        didSet {
            configurationView.backgroundColor = backgroundColor?.withAlphaComponent(0.7)
        }
    }
    //*************************
    
    override public init(frame: CGRect) {
        let frame = UIScreen.main.bounds
        super.init(frame: frame)
        configurationView = ConfigurationView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        
        fractalDrawingView = FractalDrawingView(frame: CGRect(x: 0, y: frame.height*0.38, width: frame.width, height: frame.height*0.62))
        
        configurationView.iterationsView?.delegate = self
        
        self.addSubview(fractalDrawingView)
        self.addSubview(configurationView)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupNumberOfPoints(_ number: Int) {
        configurationView.iterationsView?.iteration = self.iteration
        configurationView.setNumberOfPoints(number)
    }
    
    func setPolygonSideNumber(_ number: Int) {
        
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
    
    func movingDraw() {
        
        var iterations = self.iteration
        
        if (iterations > Constants.movingIterations ) {
            iterations = Constants.movingIterations
        }
        
        draw(iterations: iterations)
        
    }
    
    func fullDraw() {
        let iterations = self.iteration
        
        draw(iterations: iterations)
    }
    
    func draw(iterations: Int) {
        
        fractalDrawingView.iteration = iteration
        
        self.runCount += 1
        let operation = ProcessFractal(withTag: self.runCount, points: self.shapePoints, vectors: self.vectors, iterations: iterations)
        
        
        operation.completionBlock = {
            DispatchQueue.main.async {
                if (operation.TAG != self.runCount) { return }
                
                self.fractalDrawingView.lines = operation.lines
                self.fractalDrawingView.points = operation.pathPoints
                self.fractalDrawingView.draw()
                
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
    
    public func didFinishMoving() {
        reset(isMoving: false)
    }
    
    public func didChangeMove() {
        reset(isMoving: true)
    }
    
    public func didSetIteration(_ iteration: Int) {
        self.iteration = iteration
        fractalDrawingView.iteration = iteration
        fullDraw()
    }
    
    public func start() {
        setOrientationFromBounds(bounds: self.bounds)
        backgroundOperation?.cancel()
        fractalDrawingView.lines.removeAll()
        setupNumberOfPoints(numberOfPoints)
        setPolygonSideNumber(polygonSides)
        generateVectors()
        fullDraw()
    }
    
    public func reset() {
        backgroundOperation?.cancel()
        fractalDrawingView.lines.removeAll()
        setPolygonSideNumber(polygonSides)
        generateVectors()
        fullDraw()
    }
    
    public func reset(isMoving: Bool) {
        
        fractalDrawingView.lines.removeAll()
        
        generateVectors()
        
        if (isMoving) {
            movingDraw()
        } else {
            fullDraw()
        }
        
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
        
        reset()
        
    }
    
    private func setOrientationFromBounds(bounds: CGRect) {
        if bounds.width > bounds.height {
            self.orientation = UIInterfaceOrientation.landscapeLeft
        } else {
            self.orientation = UIInterfaceOrientation.portrait
        }
    }
    
    public func animateIterations() {
        self.configurationView.animateIterations()
    }
    
    public func animatePoints() {
        self.configurationView.animatePoints()
    }
    
    
}
