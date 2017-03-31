import Foundation
import UIKit

public class Colors {
    
    static let numberOfColors = 16
    
    class func getColor(hue: CGFloat) -> UIColor {
        return UIColor(hue: hue, saturation: 0.5, brightness: 0.8, alpha: 1.0)
    }
    
    class func generateColors(numberOfColors: Int) -> [UIColor] {
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
}
