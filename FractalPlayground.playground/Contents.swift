//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let PI2 = CGFloat(2*M_PI)


let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))

fractalView.radius = 0.4

fractalView.numberOfPoints = 7

fractalView.iterations = 6

fractalView.polygonSides = 7

fractalView.reset()

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true
