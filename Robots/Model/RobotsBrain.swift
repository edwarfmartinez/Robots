//
//  RobotsBrain.swift
//  Robots
//
//  Created by Anonymous Account on 17/11/22.
//

import UIKit
import Foundation

protocol RobotsBrainDelegate {
    
    func didUpdateScore(forRobot1: Bool)
    func didUpdateBoard(_ prizePosition: Int)
    func didDrawStep(_ positions: [Int], _ images: [UIImage])
    func didFailWithError(error: Error)
}


class RobotsBrain
{
    var delegate: RobotsBrainDelegate?
    var robot1VisitedNodes = [Node]()
    var robot2VisitedNodes = [Node]()
    var robot1RouteToPrize = Queue<Node>()
    var robot2RouteToPrize = Queue<Node>()
    var robotRouteToPrize = Queue<Node>()
    var robot1Map = Queue<MapNodeParent>()
    var robot2Map = Queue<MapNodeParent>()
    var robotMap = Queue<MapNodeParent>()
    var rowStartNode = 0
    var columnStartNode = 0
    var rowNextNode = 0
    var columnNextNode = 0
    var robotMapPointer = 0
    var robot1CurrentPosition: Int?
    var robot2CurrentPosition: Int?
    var robotCurrentPosition: Int?
    var prizeCoordinates: Int?
    var robot1Score = 0
    var robot2Score = 0
    var prizeRow = 0
    var prizeColumn = 0
    var inactiveQueue: DispatchQueue!
    var flagSetRivalForNewGame: Int?
    var boardNodes = [UIButton]()
    var robotReachedPrize = false
    
    //MARK: - Board Setup
    
    func setNewGame() {
        
        createInitialPoints()
        setBoardForNewGame()
        createMapsAndRoutes(robot1Position: K.robot1StartPoint, robot2Position: K.robot2StartPoint)
    }
    
    func createInitialPoints() {
        
        robot1VisitedNodes.removeAll()
        robot2VisitedNodes.removeAll()
        robot1RouteToPrize.storage.removeAll()
        robot2RouteToPrize.storage.removeAll()
        robot1Map.storage.removeAll()
        robot2Map.storage.removeAll()
        robotMap.storage.removeAll()
        
        robot1CurrentPosition = K.robot1StartPoint
        robot2CurrentPosition = K.robot2StartPoint
        robot1VisitedNodes.append(convertTagToNode(tag: K.robot1StartPoint))
        robot2VisitedNodes.append(convertTagToNode(tag: K.robot2StartPoint))
        
        //Randomly generates new Prize's position
        prizeRow = Int.random(in: K.prizePositionMin...K.prizePositionMax)
        prizeColumn = Int.random(in: K.prizePositionMin...K.prizePositionMax)
        prizeCoordinates = Int("\(prizeRow)\(prizeColumn)")
    }
    
    func setBoardForNewGame() {
        
        delegate?.didUpdateBoard(prizeCoordinates!)
    }
    
    //MARK: - Breadth First Search Algorithm
    
    func createMapsAndRoutes(robot1Position: Int, robot2Position: Int) {
        
        //The new Prize location is ready. Now let's create maps and routes for each robot to reach it
        
        robot1Map = buildMap(
            startNode: convertTagToNode(tag: robot1Position),
            visitedNodes: robot2VisitedNodes)
        
        robotMap.storage.removeAll()
        
        robot2Map = buildMap(
            startNode: convertTagToNode(tag: robot2Position),
            visitedNodes: robot1VisitedNodes)
        
        robot1RouteToPrize = buildRouteToPrize(
            robotMap: robot1Map,
            robotCurrentPosition: robot1CurrentPosition)
        
        robot2RouteToPrize = buildRouteToPrize(
            robotMap: robot2Map,
            robotCurrentPosition: robot2CurrentPosition)
    }
    
    func buildMap(startNode:Node, visitedNodes: [Node])->Queue<MapNodeParent> {
        
        rowStartNode = startNode.row
        columnStartNode = startNode.column
        
        for i in 0...K.dc.count - 1 {
            rowNextNode = rowStartNode + K.dr[i]
            columnNextNode = columnStartNode + K.dc[i]
            
            let nodeHasAlreadyBeenVisited = visitedNodes.contains {
                $0 == Node(row: rowNextNode, column: columnNextNode)}
            
            let nodeAlreadyExistsInQueue = robotMap.storage.contains {
                $0.node == Node(row: rowNextNode, column: columnNextNode)}
            
            // Skip invalid positions over the board
            if (rowNextNode >= 0 && columnNextNode >= 0)
                && (rowNextNode < K.numberOfRows && columnNextNode < K.numberOfColumns)
                && !nodeHasAlreadyBeenVisited && !nodeAlreadyExistsInQueue {
                
                robotMap.enQueue(
                    MapNodeParent(node: Node(row: rowNextNode, column: columnNextNode),
                                  parent: Node(row: rowStartNode, column: columnStartNode)))
                
                if rowNextNode == prizeRow && columnNextNode == prizeColumn {
                    robotMapPointer = robotMap.storage.count
                    break
                }
            }
        }
        robotMapPointer += 1
        
        if robotMapPointer < robotMap.storage.count {
            _ = buildMap(startNode: robotMap.storage[robotMapPointer].node,
                         visitedNodes: visitedNodes)
        }
        robotMapPointer = 0
        return robotMap
    }
    
    func buildRouteToPrize(robotMap: Queue<MapNodeParent>, robotCurrentPosition: Int?)->Queue<Node> {
        
        var robotRouteToPrize = Queue<Node>()
        
        //Check if a path between robot and Prize exists
        let robotMapContainsPrize = robotMap.storage.contains {
            $0.node == convertTagToNode(tag: prizeCoordinates!)
        }
        let robotMapContainsCurrentPosition = robotMap.storage.contains {
            $0.parent == convertTagToNode(tag: robotCurrentPosition!)
        }
        
        //If the path exists then creates the route (queue of steps)
        if robotMapContainsPrize && robotMapContainsCurrentPosition {
            
            let lastStep = robotMap.storage.filter {
                $0.node == convertTagToNode(tag: prizeCoordinates!)
            }
            
            robotRouteToPrize.enQueue(lastStep.first!.node)
            robotRouteToPrize.enQueue(lastStep.first!.parent!)
            
            var robotNextStep = robotMap.storage.filter {
                $0.node == lastStep.first!.parent
            }
            
            if robotNextStep.count > 0 {
                while robotNextStep.first!.parent != convertTagToNode(tag: robotCurrentPosition!) {
                    
                    robotNextStep = robotMap.storage.filter{
                        $0.node == robotNextStep.first!.parent
                    }
                    robotRouteToPrize.enQueue(robotNextStep.first!.node)
                }
            }
            
        }
        //robotRouteToPrize.enQueue(convertTagToNode(tag: robotCurrentPosition!))
        robotRouteToPrize.storage.reverse()
        return robotRouteToPrize
    }
    
    func changePrizePosition(newPrizePosition: Int){
        
        prizeCoordinates = newPrizePosition
        robot1RouteToPrize.storage.removeAll()
        robot2RouteToPrize.storage.removeAll()
        robot1Map.storage.removeAll()
        robot2Map.storage.removeAll()
        robotMap.storage.removeAll()
        
        let prizeRowAndColumn = convertTagToNode(tag: newPrizePosition)
        prizeRow = prizeRowAndColumn.row
        prizeColumn = prizeRowAndColumn.column
        createMapsAndRoutes(robot1Position:robot1CurrentPosition!, robot2Position: robot2CurrentPosition!)
        
    }
    
    //MARK: - Draw Path
    
  
    
    func performStepRobot1()
    {
        //print("r1Route: \(robot1RouteToPrize) prize: \(prizeCoordinates!) position: \(robot1CurrentPosition!)")
        
        usleep(useconds_t(K.stepTime))
        
        if robot1RouteToPrize.storage.count == 0 {
            return
        }
        
        let stepPositions = [robot1CurrentPosition!, convertNodeToTag(node: robot1RouteToPrize.peek!)]
        
        let images = [K.robot1ImgPreviousPosition, K.robot1ImgCurrentPosition]
        delegate?.didDrawStep(stepPositions, images)
        
        // Robot reached the prize
        if convertNodeToTag(node: robot1RouteToPrize.peek!) == prizeCoordinates {
            
            setNewGame()
            robot1Score += 1
            delegate?.didUpdateScore(forRobot1: true)
            
            
        } else {
            self.robot1CurrentPosition = convertNodeToTag(node: robot1RouteToPrize.peek!)
            _ = robot1RouteToPrize.deQueue()
            robot1VisitedNodes.append(convertTagToNode(tag: robot1CurrentPosition!))
        }
        
    }
    
    
    
    func performStepRobot2()
    {
        //print("r2Route: \(robot2RouteToPrize) prize: \(prizeCoordinates!) position: \(robot2CurrentPosition!)")
        
        usleep(useconds_t(K.stepTime))
        if robot2RouteToPrize.storage.count == 0 {
            return
        }
        
        let stepPositions = [robot2CurrentPosition!, convertNodeToTag(node: robot2RouteToPrize.peek!)]
        
        let images = [K.robot2ImgPreviousPosition, K.robot2ImgCurrentPosition]
        delegate?.didDrawStep(stepPositions, images)
        
        // Robot reached the prize
        
        if convertNodeToTag(node: robot2RouteToPrize.peek!) == prizeCoordinates {
            setNewGame()
            robot2Score += 1
            delegate?.didUpdateScore(forRobot1: false)
            
            
        } else {
            self.robot2CurrentPosition = convertNodeToTag(node: robot2RouteToPrize.peek!)
            _ = robot2RouteToPrize.deQueue()
            robot2VisitedNodes.append(convertTagToNode(tag: robot2CurrentPosition!))
        }
        
    }
    
    //MARK: - Robots Threads
    
    func startRobotsThreads(){
        
        let dispatchQueue = DispatchQueue(label: K.lblDispatchQueue, qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])
        inactiveQueue = dispatchQueue
        
        dispatchQueue.async { [self] in
            for _ in 0..<K.numberOfSteps {
                performStepRobot1()
            }
        }
        
        dispatchQueue.async { [self] in
            usleep(useconds_t(K.stepTime/2))
            for _ in 0..<K.numberOfSteps {
                performStepRobot2()
            }
        }
    }
    
}
    
    
    //MARK: - General Utilities
    
    func convertTagToNode(tag: Int)->Node {
        
        let tagString = String(tag)
        var rowNewNode = "", columnNewNode = ""
        
        if tagString.count > 1 {
            rowNewNode = tagString[0]
            columnNewNode = tagString[1]
        } else {
            rowNewNode = String(K.defaultNodePosition)
            columnNewNode = tagString[0]
        }
        
        return Node(row: Int(rowNewNode)!, column: Int(columnNewNode)!)
    }
    
    func convertNodeToTag(node: Node)->Int {
        return Int("\(String(node.row))\(String(node.column))")!
    }

