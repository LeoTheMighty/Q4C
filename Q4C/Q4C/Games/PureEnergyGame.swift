//
//  PureEnergyGame.swift
//  Q4C
//
//  Created by Leonid Belyi on 12/20/17.
//  Copyright © 2017 SoLux. All rights reserved.
//

import Foundation
import SpriteKit

class PureEnergyGame : Game {
    
    private var scene : SKScene
    
    private var touchGravity : SKFieldNode?
    private var startGravity = SKFieldNode.radialGravityField()
    
    private let radiusOfUnaffectedCircle : CGFloat = 50
    private let numPointsInWave = 180
    private let massOfPoint : CGFloat = 0.5
    
    private var waves : [Wave] = []
    private var numWaves : Int = 0
    private var originPoint : CGPoint = CGPoint()
    
    private let startGravityStrength : Float = -0.1
    
    private var startTime : TimeInterval = 0
    private let timeBetweenWaves : TimeInterval = 4.0
    
    private let backgroundColorComponent : CGFloat = 48 / 255
    private let waveColorComponent : CGFloat = 255 / 255
    
    init(scene : SKScene, currentTime : TimeInterval) {
        self.startTime = currentTime
        self.scene = scene
        
        //initialize the physics circle
        scene.backgroundColor = UIColor(red : backgroundColorComponent, green : backgroundColorComponent, blue : backgroundColorComponent, alpha : 1)
        originPoint = CGPoint(x: -scene.size.width / 2, y: -scene.size.height / 2)
        startTime = NSDate().timeIntervalSince1970
        startGravity.strength = startGravityStrength
        startGravity.position = originPoint
        scene.addChild(startGravity)
        
        waves.append(Wave(scene: scene, originPoint: originPoint, startingRadius: radiusOfUnaffectedCircle, numPointsInWave: numPointsInWave, massOfPoint: massOfPoint, startColorComponent: waveColorComponent, endColorComponent: backgroundColorComponent))
    }
    
    func update(currentTime : TimeInterval) {
        let elapsedTime = currentTime - startTime
        
        if Int(elapsedTime / timeBetweenWaves) > numWaves {
            waves.append(Wave(scene: scene, originPoint: originPoint, startingRadius: radiusOfUnaffectedCircle, numPointsInWave: numPointsInWave, massOfPoint: massOfPoint, startColorComponent : waveColorComponent, endColorComponent : backgroundColorComponent))
            numWaves+=1
        }
        
        var index : Int = 0
        for wave in waves {
            wave.updateCircle()
            if (wave.toBeDestroyed()) {
                waves.remove(at: index)
            }
            index += 1
        }
    }
    
    func startGame() {
        
    }
    
    func resumeGame() {
        
    }
    
    func saveGame() {
        
    }
    
    func userPress(point : CGPoint) {
        touchGravity = SKFieldNode.radialGravityField()
        touchGravity?.position = point
        touchGravity?.strength = -1
        scene.addChild(touchGravity!)
    }
    
    func userTouchMove(point : CGPoint) {
        touchGravity?.position = point
    }
    
    func userReleaseTouch(point : CGPoint) {
        touchGravity?.removeFromParent()
        touchGravity = nil
    }
    
    func userTap(point : CGPoint) {
        
    }
    
    func userSwipe(point : CGPoint) {
        
    }
    
    func userSwirl(point : CGPoint) {
        
    }
    
    class Wave {
        
        private let birthTime : TimeInterval
        private let lifeSpan : TimeInterval = 15
        private let originPoint : CGPoint
        private let numPointsInWave : Int
        private var pointsOfCircle : [SKNode] = []
        private let massOfPoint : CGFloat
        private let startingRadius : CGFloat
        private let circle : SKShapeNode
        private let scene : SKScene
        private let startColorComponent : CGFloat
        private let endColorComponent : CGFloat
        private var toBeDestroyedVar : Bool = false
        
        init(scene : SKScene, originPoint : CGPoint, startingRadius : CGFloat, numPointsInWave : Int, massOfPoint : CGFloat, startColorComponent : CGFloat, endColorComponent : CGFloat) {
            birthTime = NSDate().timeIntervalSince1970
            self.startColorComponent = startColorComponent
            self.endColorComponent = endColorComponent
            self.scene = scene
            self.originPoint = originPoint
            self.startingRadius = startingRadius
            self.numPointsInWave = numPointsInWave
            self.massOfPoint = massOfPoint
            pointsOfCircle = []
            circle = SKShapeNode()
            
            initCircle(scene : scene)
            scene.addChild(circle)
        }
        
        func initCircle(scene : SKScene) {
            let circlePath : CGMutablePath = CGMutablePath.init()
            
            let startAngle = -numPointsInWave / 4
            let endAngle = numPointsInWave / 2
            
            for angle in startAngle...endAngle {
                let physicsPoint = SKSpriteNode()
                physicsPoint.position.x = cos(2*CGFloat(angle)*CGFloat.pi/CGFloat(numPointsInWave)) * startingRadius
                physicsPoint.position.y = sin(2*CGFloat(angle)*CGFloat.pi/CGFloat(numPointsInWave)) * startingRadius
                physicsPoint.texture = SKTexture(image: #imageLiteral(resourceName: "hollowBall"))
                physicsPoint.physicsBody = SKPhysicsBody(texture: physicsPoint.texture!, size: CGSize(width: 0.09, height: 0.09))
                physicsPoint.physicsBody?.mass = massOfPoint
                physicsPoint.physicsBody?.pinned = false
                physicsPoint.physicsBody?.affectedByGravity = false
                physicsPoint.physicsBody?.isDynamic = true
                physicsPoint.isHidden = false
                pointsOfCircle.append(physicsPoint)
                scene.addChild(physicsPoint)
                physicsPoint.physicsBody!.applyForce(CGVector(dx: 3*physicsPoint.position.x, dy: 3*physicsPoint.position.y))
                physicsPoint.position = CGPoint(x: physicsPoint.position.x + originPoint.x, y: physicsPoint.position.y + originPoint.y)
                if angle == startAngle {
                    circlePath.move(to: physicsPoint.position)
                }
                else {
                    circlePath.addQuadCurve(to: physicsPoint.position, control: CGPoint(x: 0, y: 0))
                }
            }
            
            circle.path = circlePath
            circle.strokeColor = UIColor(red : startColorComponent, green : startColorComponent, blue : startColorComponent, alpha : 1)
            circle.lineWidth = 50
        }
        
        func updateCircle() {
            circle.removeFromParent()
            let circlePath : CGMutablePath = CGMutablePath.init()
            var nextIndex = 1
            circlePath.move(to: pointsOfCircle[0].position)
            
            for point in pointsOfCircle {
                //point.physicsBody!.applyImpulse(CGVector(dx: 1, dy: 1))
                point.physicsBody!.applyForce(GameScene.vectorFromPoints(point1: point.position, point2: circlePath.currentPoint))
                point.physicsBody!.applyForce(GameScene.vectorFromPoints(point1: point.position, point2: pointsOfCircle[nextIndex].position))
                circlePath.addLine(to: point.position)
                if nextIndex == pointsOfCircle.count - 1 {
                    nextIndex = 0
                }
                else {
                    nextIndex += 1
                }
            }
            
            let elapsedTime = NSDate().timeIntervalSince1970 - birthTime
            let timeLeft = lifeSpan - elapsedTime
            
            if (timeLeft <= 0) {
                toBeDestroyedVar = true
            }
            
            let colorComp = (startColorComponent - endColorComponent) * CGFloat((timeLeft) / (lifeSpan)) + endColorComponent
            
            circle.strokeColor = UIColor(red: colorComp, green: colorComp, blue: colorComp, alpha: CGFloat(timeLeft / lifeSpan))
            
            circlePath.addLine(to: pointsOfCircle[0].position)
            circle.path = circlePath
            circle.lineWidth = 2
            scene.addChild(circle)
        }
        
        func toBeDestroyed() -> Bool {
            return toBeDestroyedVar
        }
        
        deinit {
            circle.removeFromParent()
            
            for point in pointsOfCircle {
                point.removeFromParent()
            }
        }
    }
}
