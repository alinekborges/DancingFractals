//#-hidden-code
import Foundation

import Foundation
import UIKit
import PlaygroundSupport

var polygonSides = 5

//#-end-hidden-code

/*:
 ## Make it dance!
 
 The same way you could move the points around to create a shape, now we can program their movements and watch it dance by itself
 
 **How it works:** Set how much each point will move horizontally *(delta X)* and vertically *(delta Y)* and the duration of this movement.
 
 - Note: You can still move points around! Check how your shape reacts to the movement
 
 - Experiment: Try setting an animation for just one or two points and create a shape with your fingers and check out the results
 
 
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

let point1 = points[0]
let point2 = points[1]
let point3 = points[2]
let point4 = points[3]
let point5 = points[4]
let point6 = points[5]

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code



//#-code-completion(everything, hide)
//#-code-completion(literal)


point1.animateX(delta:  /*#-editable-code*/130/*#-end-editable-code*/, time:  /*#-editable-code*/8.0/*#-end-editable-code*/)
point1.animateY(delta:  /*#-editable-code*/105/*#-end-editable-code*/, time: /*#-editable-code*/ 6.0/*#-end-editable-code*/)

point2.animateX(delta:  /*#-editable-code*/200/*#-end-editable-code*/, time:  /*#-editable-code*/4.0/*#-end-editable-code*/)
point2.animateY(delta:  /*#-editable-code*/80/*#-end-editable-code*/, time:  /*#-editable-code*/3.0/*#-end-editable-code*/)

point3.animateX(delta:  /*#-editable-code*/210/*#-end-editable-code*/, time:  /*#-editable-code*/12.0/*#-end-editable-code*/)
point3.animateY(delta:  /*#-editable-code*/10/*#-end-editable-code*/, time:  /*#-editable-code*/6.0/*#-end-editable-code*/)

point4.animateX(delta:  /*#-editable-code*/150/*#-end-editable-code*/, time:  /*#-editable-code*/6.0/*#-end-editable-code*/)
point4.animateY(delta:  /*#-editable-code*/170/*#-end-editable-code*/, time:  /*#-editable-code*/7.0/*#-end-editable-code*/)

point5.animateX(delta:  /*#-editable-code*/70/*#-end-editable-code*/, time:  /*#-editable-code*/15.0/*#-end-editable-code*/)
point5.animateY(delta:  /*#-editable-code*/60/*#-end-editable-code*/, time:  /*#-editable-code*/7.0/*#-end-editable-code*/)

point6.animateX(delta:  /*#-editable-code*/70/*#-end-editable-code*/, time:  /*#-editable-code*/5.0/*#-end-editable-code*/)
point6.animateY(delta:  /*#-editable-code*/10/*#-end-editable-code*/, time:  /*#-editable-code*/7.0/*#-end-editable-code*/)


