//
//  ViewController.swift
//  Robots
//
//  Created by Anonymous Account on 14/11/22.
//

import UIKit
import Foundation

class RobotsController: UIViewController {
    
    @IBOutlet weak var robot1LblScore: UILabel!
    @IBOutlet weak var robot2LblScore: UILabel!
    @IBOutlet var boardNodes: [UIButton]!
    var robotsBrain = RobotsBrain()
    
    @IBAction func ChangePrizePosition(_ sender: UIButton) {
        
        let oldPrize = boardNodes.filter{$0.tag == robotsBrain.prizeCoordinates!}.first
        oldPrize!.setImage(K.availableNodeImg, for: .normal)

        robotsBrain.changePrizePosition(newPrizePosition: sender.tag)
        sender.setImage(K.prizeImgCurrentPosition, for: .normal)
       
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        robotsBrain.boardNodes = boardNodes
        robotsBrain.delegate = self
        robotsBrain.setNewGame()
        robotsBrain.startRobotsThreads()
        
        if let queueStarter = robotsBrain.inactiveQueue {
            queueStarter.activate()
        }
    }

}

//MARK: - Robots Delegates

extension RobotsController: RobotsBrainDelegate{
    
    func didUpdateBoard(_ prizeCoordinates: Int) {
        DispatchQueue.main.async { [self] in
            for i in boardNodes {
                
                switch i.tag {
                    
                case K.robot1StartPoint:
                    i.setImage(K.robot1ImgCurrentPosition, for: .normal)
                    
                case K.robot2StartPoint:
                    i.setImage(K.robot2ImgCurrentPosition, for: .normal)
                    
                case prizeCoordinates:
                    i.setImage(K.prizeImgCurrentPosition, for: .normal)
                    
                default:
                    i.setImage(K.availableNodeImg, for: .normal)
                }
            }
        }
    }
    
    func didUpdateScore(forRobot1: Bool) {
        
        DispatchQueue.main.async { [self] in
            if forRobot1 {
                robot1LblScore.text = String(robotsBrain.robot1Score)
            } else {
                robot2LblScore.text = String(robotsBrain.robot2Score)
            }
        }
    }
    
    
    func didDrawStep(_ positions: [Int], _ images: [UIImage]) {
        
        DispatchQueue.main.async { [self] in
            let currentPosition = boardNodes.filter{ $0.tag == positions.first }.first
            currentPosition!.setImage(images.first, for: .normal)
        
            let previousPosition = boardNodes.filter{ $0.tag == positions.last }.first
            previousPosition!.setImage(images.last, for: .normal)
        }
    }
   
    func didFailWithError(error: Error) {
        print(error)
    }
}
