//
//  Constants.swift
//  Robots
//
//  Created by Anonymous Account on 14/11/22.
//


import Foundation
import UIKit

struct K {
    
    static let robot1StartPoint =  0
    static let robot2StartPoint =  66
    static let numberOfColumns = 7
    static let numberOfRows = 7
    static let prizePositionMin = 1
    static let prizePositionMax = 5
    static let defaultNodePosition =  0
    static let stepTime = 2000000//1000000//500000//
    static let dr = [-1, 1, 0, 0]
    static let dc = [0, 0, 1, -1]
    static let numberOfSteps = 1000000
    static let errorDequeue = "Can't dequeue empty queue"
    static let lblDispatchQueue = "Robots Dispatch Queue"
    
    static let availableNodeImg = #imageLiteral(resourceName: "NodeAvailable")
    static let robot1ImgCurrentPosition = #imageLiteral(resourceName: "NodeRobot1Current")
    static let robot1ImgPreviousPosition = #imageLiteral(resourceName: "NodeRobot1Visited")
    static let robot2ImgCurrentPosition = #imageLiteral(resourceName: "NodeRobot2Current")
    static let robot2ImgPreviousPosition = #imageLiteral(resourceName: "NodeRobot2Visited")
    static let prizeImgCurrentPosition = #imageLiteral(resourceName: "NodePrizeToken")
}
