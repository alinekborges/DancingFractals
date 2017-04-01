//#-hidden-code

import Foundation
import UIKit
import PlaygroundSupport

Constants.initialIterations = 0

let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 390, height: 400))

fractalView.radius = 0.4

fractalView.numberOfPoints = 5

fractalView.polygonSides = 3

fractalView.backgroundColor = .black

fractalView.animateIterations()

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true

func start() {
    fractalView.start()
}

//#-end-hidden-code

/*:
 # Playing with Fractals
 
 ----
 
 *[Aline Kolczycki Borges](https://github.com/alinekborges), Mar 2017*

 The **[Koch Curve](https://en.wikipedia.org/wiki/Koch_snowflake)** (or **Koch Snowflake**) is one of the earliests fractal curves described. It appeared to the world in a paper published in 1904.
 
 The numbers on top of the screen represent each iteration. For example:
 0) **iteration 0**: The line will be just a line.
 1) **iteration 1**: The points at the top will be copied to the line below
 2) **iteration 2**: For each subline drawn at iteration 1, points will be copied again
 4) And so on...
 
 */

start()

//: [Next](@next)
