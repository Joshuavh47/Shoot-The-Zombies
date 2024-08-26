//
//  GameScene.swift
//  Shoot The Zombies
//
//  Created by Joshua Eres on 4/11/24.
//
// Josh Eres - jeeres
// Jalen Moya - jamoya
// Submitted: 4/25/24

import CoreMotion
import SpriteKit

class Zombie: SKSpriteNode{}
class Player: SKSpriteNode{}
class Bullet: SKSpriteNode{}

enum CollisionType: UInt32 {
    case player = 1
    case playerBullet = 2
    case enemy = 4
    
}
let model = GameModel()


class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    var motionManager: CMMotionManager?
    var lastSpawnTimeInterval: TimeInterval = 0
    
    let player: Player = Player(imageNamed: "Main Character")
    let scoreLabel = SKLabelNode(text: "Score: \(model.score)")
    let gameNode = SKNode()
    let pauseNode = SKNode()
    let pauseScoreLabel = SKLabelNode(text: "Score: 0")
    
    override func didMove(to view: SKView) {
        addChild(gameNode)
        print("test")
        let pauseButton:SKSpriteNode = SKSpriteNode(imageNamed: "PauseWhite")
        pauseButton.name = "pauseButton"
        pauseButton.position = CGPoint(x: -295.0, y: 150.0)
        pauseButton.size = CGSize(width: 50, height: 50)
        pauseButton.zPosition = 20
        pauseButton.alpha = 0.5
        
        scoreLabel.name = "score label"
        scoreLabel.zPosition = 20
        scoreLabel.alpha = 1
        scoreLabel.fontSize = 25
        scoreLabel.fontName = "HelveticaNeue-Bold"
        
        scoreLabel.position = CGPoint(x: 0, y: 150)
        
        gameNode.addChild(scoreLabel)
        
        gameNode.addChild(pauseButton)
        
        physicsWorld.contactDelegate = self
        
        player.name = "player"
        player.position = CGPoint(x: 0, y: 0)
        player.size = CGSize(width: 45, height: 90)
        player.zPosition = 5
        player.alpha = 1
        var playerSize: CGSize = player.size
        playerSize.width -= 30
        playerSize.height -= 30
        //player.texture = SKTexture(imageNamed: "Main Character")
        player.physicsBody = SKPhysicsBody(rectangleOf: playerSize)
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue
        player.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.restitution = 0
        player.physicsBody?.friction = 0
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.isDynamic = true
        
        gameNode.addChild(player)
        
        //physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        motionManager = CMMotionManager()
        motionManager?.startGyroUpdates()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "zombie" {
            collisionBetween(zombie: nodeA, object: nodeB)
        } else if nodeB.name == "zombie" {
            collisionBetween(zombie: nodeB, object: nodeA)
        }
    }
    
    func collisionBetween(zombie: SKNode, object: SKNode){
        if(object.name == "bullet"){
            print("bullet hit")
            object.removeFromParent()
            zombie.removeFromParent()
            model.score += 10
            scoreLabel.text = "Score: \(model.score)"
        }
        else if(object.name == "player"){
            print("Game Over")
            gameOver()
        }
    }
    
    func gameOver() {
        self.isPaused = true
        
        // Create a node for the game over screen
        let gameOverNode = SKNode()
        gameOverNode.zPosition = 100
        
        // Add a semi-transparent black background to the game over screen
        let background = SKSpriteNode(color: .black, size: self.size)
        background.alpha = 0.8
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverNode.addChild(background)
        
        // Add the "GAME OVER" label
        let gameOverLabel = SKLabelNode(text: "GAME OVER")
        gameOverLabel.fontName = "HelveticaNeue-Bold"
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        gameOverNode.addChild(gameOverLabel)
        
        // Add the final score label
        let scoreText = "You scored: \(model.score)!"
        let scoreLabel = SKLabelNode(text: scoreText)
        scoreLabel.fontName = "HelveticaNeue-Bold"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverNode.addChild(scoreLabel)
        
        // Add the "Restart" button
        let restartLabel = SKLabelNode(text: "Restart")
        restartLabel.name = "restart"
        restartLabel.fontName = "HelveticaNeue-Bold"
        restartLabel.fontSize = 30
        restartLabel.fontColor = .white
        restartLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        gameOverNode.addChild(restartLabel)
        
        // Add the "Main Menu" button
        let mainMenuLabel = SKLabelNode(text: "Main Menu")
        mainMenuLabel.name = "mainMenu"
        mainMenuLabel.fontName = "HelveticaNeue-Bold"
        mainMenuLabel.fontSize = 30
        mainMenuLabel.fontColor = .white
        mainMenuLabel.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        gameOverNode.addChild(mainMenuLabel)
        
        let playerName = "Player" 
        DataModelManager.shared.saveScore(playerName: playerName, score: model.score)
        // Add the game over node to the scene
        addChild(gameOverNode)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let scene = self.scene else { return }
        let location = touch.location(in: scene)
        print(location)

        // Check if the game is not paused and if the touched point is not the pause button
        if !gameNode.isPaused && self.atPoint(location).name != "pauseButton" {
            let bullet = Bullet(imageNamed: "bullet")
            bullet.name = "bullet"
            bullet.position = player.position
            bullet.zPosition = 6
            var bulletSize = bullet.size
            bulletSize.width -= 5
            bulletSize.height -= 5

            bullet.physicsBody = SKPhysicsBody(rectangleOf: bulletSize)
            bullet.physicsBody?.categoryBitMask = CollisionType.playerBullet.rawValue
            bullet.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue
            bullet.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue
            bullet.physicsBody?.allowsRotation = false
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.mass = 0.001
            bullet.zRotation = model.calcBulletAngle(touchLocation: location, playerLocation: player.position)
            gameNode.addChild(bullet)
            model.bulletsInPlay.append(bullet)
            print("Bullet added")
            bullet.physicsBody?.applyImpulse(model.calculateBulletVector(touchLocation: location, playerLocation: player.position, power: 0.75))
        }

        // Handle other touch interactions on specific nodes
        for t in touches {
            let node = self.atPoint(t.location(in: self))

            switch node.name {
            case "pauseButton":
                if !gameNode.isPaused {
                    print("Pause")
                    pauseGame()
                    addChild(pauseNode)
                }
            case "resume":
                pauseNode.removeFromParent()
                gameNode.isPaused = false
                player.physicsBody?.isDynamic = true
            case "home label":
                if let homeScene = SKScene(fileNamed: "OpeningScene") {
                    homeScene.scaleMode = .resizeFill
                    view?.presentScene(homeScene)
                    model.score = 0
                }
            case "restart":
                restartGame()
            case "mainMenu":
                goToMainMenu()
            default:
                break
            }
        }
    }
    
    func restartGame() {
        // Reset score
        model.score = 0
        
        // Remove all zombies from the scene
        for zombie in model.zombiesInPlay {
            zombie.removeFromParent()
        }
        model.zombiesInPlay.removeAll()
        
        // Reset other game state variables as needed
        
        // Present the game scene again
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .resizeFill
            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }

    func goToMainMenu() {
        // Reset score
        model.score = 0
        
        // Remove all zombies from the scene
        for zombie in model.zombiesInPlay {
            zombie.removeFromParent()
        }
        model.zombiesInPlay.removeAll()
        
        // Reset other game state variables as needed
        
        // Present the main menu scene again
        if let homeScene = SKScene(fileNamed: "OpeningScene") {
            homeScene.scaleMode = .resizeFill
            self.view?.presentScene(homeScene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }

    
    func pauseGame(){
        gameNode.isPaused = true
        player.physicsBody?.isDynamic = false

        let backgrnd = SKSpriteNode(color: UIColor.gray, size: frame.size)
        backgrnd.name = "background"
        backgrnd.position = CGPoint(x: 0, y: 0)
        backgrnd.zPosition = 50

        // Remove existing pauseScoreLabel if it exists
        pauseNode.childNode(withName: "pauseScoreLabel")?.removeFromParent()

        let pauseScoreLabel = SKLabelNode(text: "Score: \(model.score)")
        pauseScoreLabel.name = "pauseScoreLabel" // Assign a name for easy identification
        pauseScoreLabel.fontName = "HelveticaNeue-Bold"
        pauseScoreLabel.fontSize = 25
        pauseScoreLabel.zPosition = 100
        pauseScoreLabel.position = CGPoint(x: 0, y: -100)

        let resumeLabel = SKLabelNode(text: "Resume")
        resumeLabel.name = "resume"
        resumeLabel.zPosition = 100
        resumeLabel.position = CGPoint(x: 0, y: 100)
        
        let homeLabel = SKLabelNode(text: "Main Menu")
        homeLabel.name = "home label"
        homeLabel.zPosition = 100
        homeLabel.position = CGPoint(x: 0, y: 0)

        // Ensure all children are added only once
        if pauseNode.children.isEmpty {
            pauseNode.addChild(backgrnd)
            pauseNode.addChild(resumeLabel)
            pauseNode.addChild(homeLabel)
        }
        pauseNode.addChild(pauseScoreLabel) // Add pauseScoreLabel after checking other children
    }

    
    
    
    func addZombie(at position: CGPoint) {
        let zombie = Zombie(imageNamed: "Zombie Character")
        zombie.name = "zombie"
        zombie.position = position
        zombie.size = player.size
        var rect = player.size
        rect.width -= 30
        rect.height -= 30
        zombie.physicsBody = SKPhysicsBody(rectangleOf: rect)
        zombie.physicsBody?.isDynamic = false
        
        zombie.physicsBody?.categoryBitMask = CollisionType.enemy.rawValue
        zombie.physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.playerBullet.rawValue
        zombie.physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.playerBullet.rawValue
        gameNode.addChild(zombie)
        model.zombiesInPlay.append(zombie)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager?.gyroData{
            if(!gameNode.isPaused){
                physicsWorld.gravity = CGVector(dx: accelerometerData.rotationRate.x*5, dy: accelerometerData.rotationRate.y*5)
            }
            else{
                physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            }
            //print(physicsWorld.gravity)
        }
        keepPlayerInBounds()
        for child in children{
            if child is Bullet{
                if(!frame.intersects(child.frame)){
                    child.removeFromParent()
                    if let index = model.bulletsInPlay.firstIndex(of: child as! Bullet){
                        model.bulletsInPlay.remove(at: index)
                        print("removed")
                        print(model.bulletsInPlay.count)
                    }
                }
            }
        }
        spawnZombiesIfNeeded(currentTime)
                
                // Update zombie positions
        moveZombiesTowardsPlayer()
    }
    
    func spawnZombiesIfNeeded(_ currentTime: TimeInterval) {
        if(!gameNode.isPaused){
            // Adjust spawn rate as needed
            if currentTime - lastSpawnTimeInterval > 1 {
                lastSpawnTimeInterval = currentTime
                
                // Spawn zombies from the front or back randomly
                let spawnFromFront = Bool.random()
                
                // Adjust spawn position based on the direction of movement
                let spawnY: CGFloat = spawnFromFront ? frame.maxY : frame.minY
                let spawnX = CGFloat.random(in: frame.minX...frame.maxX)
                
                addZombie(at: CGPoint(x: spawnX, y: spawnY))
            }
        }
    }
    func moveZombiesTowardsPlayer() {
        if(!gameNode.isPaused){
            for zombie in model.zombiesInPlay {
                // Move zombies towards the player's position
                let angle = atan2(player.position.y - zombie.position.y, player.position.x - zombie.position.x)
                let speed: CGFloat = 1.0 // Adjust the speed as needed
                let dx = speed * cos(angle)
                let dy = speed * sin(angle)
                zombie.zRotation = angle
                if(dx < 0){
                    zombie.texture = SKTexture(imageNamed: "Zombie Character Left")
                    zombie.zRotation = angle - .pi
                }
                else{
                    zombie.texture = SKTexture(imageNamed: "Zombie Character")
                }
                zombie.position.x += dx
                zombie.position.y += dy
                zombie.size = CGSize(width: 45, height: 90)
            }
        }
    }
    
    func keepPlayerInBounds(){
        if (player.position.x < frame.minX + player.size.width/2+10){
            player.position.x = frame.minX + player.size.width/2+10
        }
        if (player.position.y < frame.minY + player.size.height/2+10){
            player.position.y = frame.minY + player.size.height/2+10
        }
        if (player.position.x > frame.maxX - player.size.width/2-10){
            player.position.x = frame.maxX - player.size.width/2-10
        }
        if (player.position.y > frame.maxY - player.size.height/2-5){
            player.position.y = frame.maxY - player.size.height/2-5
        }
    }
}
