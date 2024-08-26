//
//  GameModel.swift
//  Shoot The Zombies
//
//  Created by Joshua Eres on 4/12/24.
//
// Josh Eres - jeeres
// Jalen Moya - jamoya
// Submitted: 4/25/24

import Foundation

class GameModel {
    
    var bulletsInPlay: [Bullet] = []
    var zombiesInPlay: [Zombie] = []
    var highScores: [HighScore] = []
    var score: Int = 0
    func calcBulletAngle(touchLocation: CGPoint, playerLocation: CGPoint) -> CGFloat{
        let x: CGFloat = touchLocation.x - playerLocation.x
        let y: CGFloat = touchLocation.y - playerLocation.y
        var ang: CGFloat = atan(y/x)
        if(x<0){
            ang += .pi
        }
        
        return ang
        
    }
    
    func calculateBulletVector(touchLocation: CGPoint, playerLocation: CGPoint, power: CGFloat) -> CGVector {
        let x: CGFloat = touchLocation.x - playerLocation.x
        let y: CGFloat = touchLocation.y - playerLocation.y
        let hyp:CGFloat = sqrt(x*x + y*y)
        return CGVector(dx: (x/hyp)*power, dy: (y/hyp)*power)
    }
}
