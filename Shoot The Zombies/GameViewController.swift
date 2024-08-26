//
//  GameViewController.swift
//  Shoot The Zombies
//
//  Created by Joshua Eres on 4/11/24.
//
// Josh Eres - jeeres
// Jalen Moya - jamoya
// Submitted: 4/25/24

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "OpeningScene") {
                // Set the scale mode to scale to fit the window
                
                scene.scaleMode = .resizeFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
        }
    }
    
    func goToHighScores() {
        // Fetch high scores from the data model manager
        let highScores = DataModelManager.shared.fetchHighScores()
        
        // Present the HighScoreTableViewController
        let highScoreVC = HighScoreTableViewController()
        highScoreVC.model.highScores = highScores // Pass the high scores array to the table view controller
        navigationController?.pushViewController(highScoreVC, animated: true)
    }
    
    

    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscapeRight
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
