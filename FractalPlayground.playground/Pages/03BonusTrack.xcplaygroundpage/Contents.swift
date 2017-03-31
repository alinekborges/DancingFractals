//: [Previous](@previous)

import Foundation

import Foundation
import UIKit
import PlaygroundSupport

Constants.initialIterations = 0

let fractalView = FractalView(frame: CGRect(x: 0, y: 0, width: 472, height: 600))

fractalView.radius = 0.4

fractalView.numberOfPoints = 7

fractalView.polygonSides = 3

fractalView.start()

fractalView.animateIterations()

PlaygroundPage.current.liveView = fractalView
PlaygroundPage.current.needsIndefiniteExecution = true
