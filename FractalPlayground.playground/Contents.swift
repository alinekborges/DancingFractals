//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let PI2 = CGFloat(2*M_PI)


let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))


fractalView.radius = 0.5

fractalView.numberOfPoints = 7

fractalView.iterations = 4

fractalView.polygonSides = 5

fractalView.reset()

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true
