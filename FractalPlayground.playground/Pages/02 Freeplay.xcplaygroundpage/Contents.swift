//#-hidden-code
import UIKit
import PlaygroundSupport


var fractalRadius:CGFloat = 0.4
var numberOfPoints = 7
var polygonSides = 5
var backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//#-end-hidden-code

/*:
 # Freeplay
 
 ----
 
 In this example, we will create some really cool shapes based on the same concept of **Koch Snowflake**.
 
 Move the points around and see how the shape creates itself.
 
 Customize the options to find different beautiful shapes.
 
 **Tip:** Go fullscreen for more space to play around
 
 - Note: There is some pretty heavy calculations each time the point moves around, so avoid using large numbers. It can get laggy laggy and slow. Use up to 9 and you will be fine
 
 
 
 - Experiment: Change the number of iterations on the top buttons to see check different looks for the same point configuration.
 
 
 
 - Experiment: Can you create a snowflake like shape? Use a hexagon for that

 
 **Don't forget you can save your art as image and even create a movie with it! Use the tools menu at the top right position**
 
*/

//#-code-completion(everything, hide)
//#-code-completion(literal, show, color)
//This determines the radius of the fractal drawn into the screen
fractalRadius = /*#-editable-code*/0.4/*#-end-editable-code*/



//This will determine the number of points you can move around and play
numberOfPoints = /*#-editable-code*/7/*#-end-editable-code*/



//This will determine how many sides there will be in the basic polygon. For example, 3 means a triangle and 4 means a square
polygonSides = /*#-editable-code*/6/*#-end-editable-code*/

backgroundColor = /*#-editable-code*/#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)/*#-end-editable-code*/


//#-hidden-code
let fractal = FractalView(frame: CGRect(x: 0, y: 0, width: 400, height: 420))

fractal.radius = fractalRadius

fractal.numberOfPoints = numberOfPoints

fractal.polygonSides = polygonSides

fractal.backgroundColor = backgroundColor

fractal.start()

PlaygroundPage.current.liveView = fractal
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code

//: [Next](@next)
