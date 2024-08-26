//
//  GameScene.swift
//  Shoot The Zombies
//
//  Created by Joshua Eres on 4/11/24.
//
// Josh Eres - jeeres
// Jalen Moya - jamoya
// Submitted: 4/25/24

import SpriteKit


class OpeningScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        let startGame: SKSpriteNode = SKSpriteNode()
        startGame.name = "startGame"
        startGame.position = CGPoint(x: 0.0, y: -60.0)
        startGame.size = CGSize(width: 190, height: 45)
        
        startGame.zPosition = CGFloat(20.0)
        
        
        addChild(startGame)
        
        let highScoresLabel:SKLabelNode = SKLabelNode(text: "View High Scores")
        highScoresLabel.name = "high scores label"
        highScoresLabel.fontSize = 25
        highScoresLabel.position = CGPoint(x: 0, y: -130)
        highScoresLabel.zPosition = 30
        addChild(highScoresLabel)
        
        let creditsLabel: SKLabelNode = SKLabelNode(text: "Credits")
        creditsLabel.name = "credits label"
        creditsLabel.fontSize = 15
        creditsLabel.fontColor = UIColor.yellow
        creditsLabel.position = CGPoint(x: -200, y: -120)
        creditsLabel.zPosition = 30
        addChild(creditsLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            if touchedNode.name == "startGame" {
                print("Start game tapped")
                
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .resizeFill
                    self.view?.presentScene(scene)
                }
            } else if touchedNode.name == "high scores label" {
                print("High scores tapped")
                
                // Initialize HighScoreTableViewController
                let highScoreVC = HighScoreTableViewController()
                
                // Embed HighScoreTableViewController in a navigation controller
                let navController = UINavigationController(rootViewController: highScoreVC)
                navController.modalPresentationStyle = .fullScreen
                
                // Present the navigation controller
                self.view?.window?.rootViewController?.present(navController, animated: true, completion: nil)
            } else if(touchedNode.name == "credits label"){

                
                view!.presentScene(SKScene(fileNamed: "CreditsScene"))
                
                
            }
        }
    }


    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
