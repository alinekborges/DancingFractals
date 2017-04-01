//#-hidden-code
import Foundation

import Foundation
import UIKit
import PlaygroundSupport

var polygonSides = 5
var backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)


//#-end-hidden-code

/*:
 # Make it dance!
 
 ----
 
 The same way you could move the points around to create a shape, now we can program their movements and watch it dance by itself
 
 **How it works:** Set how much each point will move horizontally *(animateX)* and vertically *(animateY)* and the duration of this movement.
 
 - Note: You can still move points around with yout finger! Check how your shape reacts to the movement
 


 - Experiment: Try setting an animation for just one or two points and create a shape with your fingers. **Tip:** Just set animation to zero when you don't want it to move
 
 
 **Don't forget you can save your art as image and even create a movie with it! Use the tools menu at the top right position**
 
 */

//#-hidden-code
Constants.initialIterations = 3
Constants.maxIterations = 4

let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 472, height: 480))

fractalView.radius = 0.4

fractalView.numberOfPoints = 6

fractalView.polygonSides = 7

fractalView.start()

fractalView.animatePoints()

let points = fractalView.configurationView.mainPoints

let p1 = points[0]
let p2 = points[1]
let p3 = points[2]
let p4 = points[3]
let p5 = points[4]
let p6 = points[5]

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code
//#-code-completion(everything, color, hide)
backgroundColor = /*#-editable-code*/#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)/*#-end-editable-code*/

p1.animateX(delta:/*#-editable-code*/160/*#-end-editable-code*/, time:/*#-editable-code*/8/*#-end-editable-code*/)
p1.animateY(delta:/*#-editable-code*/95/*#-end-editable-code*/, time:/*#-editable-code*/ 6/*#-end-editable-code*/)

p2.animateX(delta:/*#-editable-code*/290/*#-end-editable-code*/, time:/*#-editable-code*/4/*#-end-editable-code*/)
p2.animateY(delta:/*#-editable-code*/80/*#-end-editable-code*/, time:/*#-editable-code*/3/*#-end-editable-code*/)

p3.animateX(delta:/*#-editable-code*/210/*#-end-editable-code*/, time:/*#-editable-code*/12/*#-end-editable-code*/)
p3.animateY(delta:/*#-editable-code*/10/*#-end-editable-code*/, time:/*#-editable-code*/6/*#-end-editable-code*/)

p4.animateX(delta:/*#-editable-code*/120/*#-end-editable-code*/, time:/*#-editable-code*/6/*#-end-editable-code*/)
p4.animateY(delta:/*#-editable-code*/160/*#-end-editable-code*/, time:/*#-editable-code*/7/*#-end-editable-code*/)

p5.animateX(delta:/*#-editable-code*/70/*#-end-editable-code*/, time:/*#-editable-code*/15/*#-end-editable-code*/)
p5.animateY(delta:/*#-editable-code*/60/*#-end-editable-code*/, time:/*#-editable-code*/7/*#-end-editable-code*/)

p6.animateX(delta:/*#-editable-code*/70/*#-end-editable-code*/, time:/*#-editable-code*/5/*#-end-editable-code*/)
p6.animateY(delta:/*#-editable-code*/10/*#-end-editable-code*/, time:/*#-editable-code*/7/*#-end-editable-code*/)


//#-hidden-code
fractalView.backgroundColor = backgroundColor
//#-end-hidden-code
