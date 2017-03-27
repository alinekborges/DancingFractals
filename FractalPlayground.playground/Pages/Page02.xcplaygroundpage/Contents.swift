//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let PI2 = CGFloat(2*M_PI)


let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 600, height: 300))

fractalView.radius = 0.4

fractalView.numberOfPoints = 7

//fix for 6 sides
fractalView.polygonSides = 5

fractalView.start()

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true
