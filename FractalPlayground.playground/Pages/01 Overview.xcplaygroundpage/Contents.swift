//#-hidden-code

import Foundation
import UIKit
import PlaygroundSupport

Constants.initialIterations = 0

let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 390, height: 400))

fractalView.radius = 0.4

fractalView.numberOfPoints = 7

fractalView.polygonSides = 3

fractalView.start()

fractalView.animateIterations()

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true

//#-end-hidden-code

/*:
 ## Playing with Fractals
 
 ----
 
 *[Aline Kolczycki Borges](https://github.com/alinekborges), Mar 2017*

 **Fractal** is a term used for the first time by Mandelbrot, in 1975. He defined it as a *"rough or fragmented geometric shape that can be split into parts, each of which is (at least approximately) a reduced-size copy of the whole"*
 
 In this example, we will reproduce again and again the shape used by the points you see in top control space.

 The numbers on top of the screen represent each iteration. For example:
 0) **iteration 0**: The line will be just a line.
 1) **iteration 1**: The points at the top will be copied to the line below
 2) **iteration 2**: For each subline drawn at iteration 1, points will be copied again
 3) **iteration 3**: For each subline drawn at iteration 2, points will be copied again
 4) And so on...
 
 
 */
