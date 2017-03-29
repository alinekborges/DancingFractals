//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 800, height: 420))

fractalView.radius = 0.4

fractalView.numberOfPoints = 7

fractalView.polygonSides = 4

fractalView.start()

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true
