import Foundation
import UIKit

public protocol IterationsDelegate {
    func didSetIteration(_ iteration: Int)
}

public class IterationsView: UIView {
    
    var buttons : [UIButton] = []
    
    var buttonSize: CGSize = CGSize.zero
    
    var delegate: IterationsDelegate?

    public init() {
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .red
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupButtons() {
        
        let size = self.frame.height
        buttonSize = CGSize(width: size, height: size)
        
        var origin = CGPoint(x: size, y: 0)
        for i in 0..<Constants.maxIterations {
            let button = UIButton()
            button.frame.size = buttonSize
            button.frame.origin = origin
            buttons.append(contentsOf: buttons)
            self.addSubview(button)
            button.backgroundColor = .yellow
            button.tag = i
            
            button.addTarget(self, action: #selector(self.onClick(button:)), for: .touchUpInside)
            origin.x += size * 2
        }
    }
    
    func onClick(button: UIButton) {
        delegate?.didSetIteration(button.tag)
    }
}
