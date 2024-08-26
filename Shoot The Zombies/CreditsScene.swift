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


class CreditsScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        let bckgrnd: SKSpriteNode = SKSpriteNode(color: UIColor(white: 0.15, alpha: 1), size: self.size)
        bckgrnd.name = "background"
        bckgrnd.position = .zero
        bckgrnd.zPosition = 1
        addChild(bckgrnd)
        let back: SKLabelNode = SKLabelNode(text: "< Back")
        back.name = "back"
        back.position = CGPoint(x: -280, y: 150)
        back.zPosition = 20
        back.fontSize = 20
        addChild(back)
        
        let creditsTitle: SKLabelNode = SKLabelNode(text: "Credits")
        creditsTitle.name = "credits title"
        creditsTitle.zPosition = 20
        creditsTitle.fontSize = 30
        creditsTitle.position = CGPoint(x: 0, y: 130)
        creditsTitle.fontName = "HelveticaNeue-Bold"
        addChild(creditsTitle)
        
        let creds: SKLabelNode = SKLabelNode(text: "Bullet texture - https://opengameart.org/content/spaceship-bullet\nZombie texture - https://opengameart.org/content/zombie-character\nMain character texture - https://opengameart.org/content/2d-hero-guy-character\nBackground texture - https://opengameart.org/content/background-5")
        creds.name = "text"
        creds.numberOfLines = 4
        creds.position = .zero
        creds.zPosition = 20
        creds.fontSize = 17
        addChild(creds)
        print("test")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            if(touchedNode.name == "back"){
                self.view?.presentScene(SKScene(fileNamed: "OpeningScene"))
            }
        }
    }


    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
