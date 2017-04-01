import Foundation
import UIKit


//Each point is represented by a vector, with the start point, angle, distance and full lenght
public class FVector {
    var point: CGPoint
    var angle: CGFloat
    var d: CGFloat
    var lenght: CGFloat
    
    public init(point: CGPoint, origin: CGPoint, end: CGPoint){
        let x = point.x - origin.x
        let y = point.y - origin.y
        
        self.angle = origin.angleTo(point)
        self.d = origin.distanceTo(point)
        self.point = CGPoint(x: x, y: y)
        
        self.lenght = origin.distanceTo(end)
        
    }
    
    //Pass the new origin and angle and will return the correspondent point in the new plane applying scale, translation and rotate
    func applyTransform(newOrigin origin:CGPoint, lenght: CGFloat, angle: CGFloat) -> CGPoint {
        
        let a = -(self.angle + angle)
        
        let scale = lenght / self.lenght
        
        let d = self.d * scale
        
        let newY = d * sin(a) + origin.y
        let newX = d * cos(a) + origin.x
        
        return CGPoint(x: newX, y: newY)
        
    }
}
