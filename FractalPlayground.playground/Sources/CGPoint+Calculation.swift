import Foundation
import UIKit

let PI2 = CGFloat(2*M_PI)
let PI = CGFloat(M_PI)

extension CGPoint {
    //simplify calculations of distance between to CGPoints
    func distanceTo(_ point: CGPoint) -> CGFloat {
        let x = self.x - point.x
        let y = self.y - point.y
        return sqrt(x*x + y*y)
    }
    
    
    //simplify calculation of angle between two CGPoints
    func angleTo(_ point: CGPoint) -> CGFloat {
        let x = (point.x - self.x)
        let y = -(point.y - self.y) //y is inverted in graphical axis
        var a:CGFloat = 0
        //arc tg isn't a continuous function
        //for some x and y variations, it needs to be added or removed M_PI (180 degrees)
        //for correct angle calculations
        
       if (x < 0 && y >= 0) {
            a = atan(y/x) - PI
        } else if (x < 0 && y < 0) {
            a = atan(y/x) + PI
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
