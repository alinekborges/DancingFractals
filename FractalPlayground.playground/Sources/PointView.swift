import Foundation
import UIKit

public protocol FinishMovingDelegate {
    func didFinishMoving()
    func didChangeMove()
}

public class PointView: UIView, UIGestureRecognizerDelegate {
    let size = CGSize(width: 26.0, height: 26.0)
    let subsize = CGSize(width: 12.0, height: 12.0)
    
    public init(center: CGPoint, color: UIColor) {
        super.init(frame: CGRect(origin: center, size: size))
        self.backgroundColor = .clear
        self.center = center
        
        let subpoint = UIView()
        subpoint.frame.size = self.subsize
        subpoint.center = CGPoint(x: 13.0, y: 13.0)
        subpoint.backgroundColor = color
        subpoint.layer.cornerRadius = subpoint.frame.height/2
        self.addSubview(subpoint)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
