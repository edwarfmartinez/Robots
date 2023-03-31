//
//  RobotsTests.swift
//  RobotsTests
//
//  Created by Anonymous Account on 14/11/22.
//

import XCTest
@testable import Robots

final class RobotsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    var robotsBrain = RobotsBrain()
    var robotsController = RobotsController()
    
    func test1CreateInitialPoints() throws {
        robotsBrain.createInitialPoints()
        XCTAssertEqual(robotsBrain.robot1CurrentPosition, K.robot1StartPoint)
        XCTAssertEqual(robotsBrain.robot2CurrentPosition, K.robot2StartPoint)
        XCTAssertLessThanOrEqual(robotsBrain.prizeRow, K.prizePositionMax)
        XCTAssertLessThanOrEqual(robotsBrain.prizeColumn, K.prizePositionMax)
        XCTAssertGreaterThanOrEqual(robotsBrain.prizeRow, K.prizePositionMin)
        XCTAssertGreaterThanOrEqual(robotsBrain.prizeRow, K.prizePositionMin)
    }
    
    
    
    func test2SetBoardForNewGame() throws {
        
        robotsBrain.prizeCoordinates = 33
        robotsBrain.robot1CurrentPosition = 0
        robotsBrain.robot2CurrentPosition = 66
        
        robotsBrain.createMapsAndRoutes(robot1Position: 0, robot2Position: 66)
        
        XCTAssertEqual(robotsBrain.robot1RouteToPrize.storage.count,0)
        XCTAssertEqual(robotsBrain.robot2RouteToPrize.storage.count,6)
        
    }
    
    func testPerformance() throws {
        self.measure {
            robotsBrain.createInitialPoints()
            robotsBrain.createMapsAndRoutes(robot1Position: 0, robot2Position: 66)
        }
    }

}
