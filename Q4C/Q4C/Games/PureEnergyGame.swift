//
//  PureEnergyGame.swift
//  Q4C
//
//  Created by Leonid Belyi on 12/20/17.
//  Copyright © 2017 SoLux. All rights reserved.
//
// Walking across
// THe sitting room
// I turn the television on
// kraft und macht
// six saintly shrouded men move across the lawn

import Foundation
import SpriteKit


/* Overview:
 *
 * Actions:
 *  - Swipe
 *      - Pushes the particles
 *  - Tap
 *      - Combines two paticles together to create a greater molecule
 *  - Swirl
 *      - Congregates the molecules together to create
 *
 * Objects:
 *
 *
 * Transition (to next):
 *
 * UserDefaults:
 *
 */
class PureEnergyGame : Game {
    
    private var scene : SKScene
    
    //private var touchGravity : SKFieldNode?
    private var startGravity = SKFieldNode.radialGravityField()
    private var swipeGravity : [SKFieldNode] = []
    private let numSwipeGravityPoints = 5
    private let swipeStrength : CGFloat = 4.0
    private var swipeStartTime : TimeInterval = 0
    private let swipeTime : TimeInterval = 3.0

    private let radiusOfUnaffectedCircle : CGFloat = 25
    private let numPointsInWave = 120
    private let massOfPoint : CGFloat = 0.5
    
    private var waves : [Wave] = []
    private var numWaves : Int = 0
    private var originPoint : CGPoint = CGPoint()
    private let touchingRadius : CGFloat = 9
    
    private var protons : [Proton] = []
    private let protonsPerWave : Int = 10
    
    private let startGravityStrength : Float = -0.25
    
    private var startTime : TimeInterval = 0
    private let timeBetweenWaves : TimeInterval = 2.5
    
    private let backgroundColorComponent : CGFloat = 36 / 255
    private let waveColorComponent : CGFloat = 255 / 255
    
    private var complexity : Int = 0
    private var complexityCounter : SKLabelNode!
    
    //private let wall : SKNode
    
    // Collision bit masks
    let waveCategory  : UInt32 = 0x1 << 1
    let protonCategory : UInt32 = 0x1 << 2
    let wallCategory : UInt32 = 0x1 << 3
    
    // Field bit masks NOT IMPLEMENTED
    let protonGravityCategory : UInt32 = 0x1 << 4
    let startGravityCategory : UInt32 = 0x1 << 5
    let touchGravityCategory : UInt32 = 0x1 << 6
    
    let protonMovementBiasPoint : CGPoint
    
    // FOR TESTING PORPOISES
    private var particle : SKSpriteNode
    private var particleR : SKSpriteNode
    
    //private let defaults = UserDefaults.standard
    
    init(scene : SKScene, currentTime : TimeInterval) {
        
        // Check for userdefaults
        // Load if necessary and start new game if applicable
        
        self.startTime = currentTime
        self.scene = scene
        
        scene.backgroundColor = UIColor(red : backgroundColorComponent, green : backgroundColorComponent, blue : backgroundColorComponent, alpha : 1)
        originPoint = CGPoint(x: -scene.size.width / 2, y: -scene.size.height / 2)
        startTime = NSDate().timeIntervalSince1970
        startGravity.strength = startGravityStrength
        startGravity.position = originPoint
        scene.addChild(startGravity)
        
        waves.append(Wave(scene: scene, originPoint: originPoint, startingRadius: radiusOfUnaffectedCircle, numPointsInWave: numPointsInWave, massOfPoint: massOfPoint, startColorComponent: waveColorComponent, endColorComponent: backgroundColorComponent, category: waveCategory, collisionMask: 0))
        
        complexityCounter = SKLabelNode(fontNamed: "Copperplate")
        complexityCounter.text = "Complexity: 0"
        complexityCounter.fontColor = SKColor.white
        complexityCounter.verticalAlignmentMode = .top
        complexityCounter.position = CGPoint(x: 115, y: 400)
        
        scene.addChild(complexityCounter)
        
        particle = SKSpriteNode(imageNamed: "ball")
        particle.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        particle.size = CGSize(width: 25, height: 25)
        scene.addChild(particle)
        particleR = SKSpriteNode(imageNamed: "ball")
        particleR.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        particleR.size = CGSize(width: 15, height: 15)
        scene.addChild(particleR)
        
        let p = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: scene.size.width , height: scene.size.height))
        p.categoryBitMask = wallCategory
        p.collisionBitMask = protonCategory
        let rect : CGRect = scene.frame
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: rect.minX - 10, y: rect.minY - 10, width: rect.width + 20, height: rect.height + 20))
        
        protonMovementBiasPoint = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
    }
    
    func saveData() {
        
    }
    
    func loadData() {
        
    }
    
    func update(currentTime : TimeInterval) {
        let elapsedTime = currentTime - startTime
        // If the elapsed time calls for another wave, create another one
        if Int(elapsedTime / timeBetweenWaves) > numWaves {
            // Append another wave to the waves array
            waves.append(Wave(scene: scene, originPoint: originPoint, startingRadius: radiusOfUnaffectedCircle, numPointsInWave: numPointsInWave, massOfPoint: massOfPoint, startColorComponent : waveColorComponent, endColorComponent : backgroundColorComponent, category: waveCategory, collisionMask: 0))
            numWaves+=1
            
            // Update the label
            //complexity = numWaves
            //complexityCounter.text = "Complexity: \(complexity)"
        }
        var ifRepeat = false;
        repeat {
            ifRepeat = false;
            var index : Int = 0
            for wave in waves {
                wave.updateCircle()
                if (wave.toBeDestroyed()) {
                    waves.remove(at: index)
                    ifRepeat = true;
                    break;
                }
                else if (index + 1) < waves.count {
                    if wave.isTouching(wave : waves[index + 1]) {
                        // Do the touching :)
                        // wave and waves[index + 1]
                        // both of them need to be removed
                        complexity+=1
                        complexityCounter.text = "Complexity: \(complexity)"
                        protAppear(wave: waves[index])
                        waves.remove(at: index)
                        protAppear(wave: waves[index])
                        waves.remove(at: index)
                        ifRepeat = true;
                        break;
                    }
                    else {
                        index += 1
                    }
                }
            }
        } while(ifRepeat);
        
        for p in protons {
            p.randomMovement(withBiasToward: protonMovementBiasPoint)
        }
        
        // DELETE THE GRAVITY THINGS IN THE SKFIELDNODE ARRAY AFTER A WHILE
    }
    
    func protAppear(wave : Wave) {
        for _ in 0..<protonsPerWave {
            let prot : Proton = Proton(scene: scene, pos: wave.getRandomCirclePos(), vel: randomVector(randComponent: 500.0), category: protonCategory,
                                       collisionMask: protonCategory | wallCategory)
            protons.append(prot)
        }
    }
    
    func randomVector(randComponent : CGFloat) -> CGVector {
        let dx = CGFloat(((drand48() * 2) - 1.0)) * randComponent
        let dy = CGFloat(((drand48() * 2) - 1.0)) * randComponent
        return CGVector(dx: dx, dy: dy)
    }
    
    func userPress(point : CGPoint) {
        //touchGravity = SKFieldNode.radialGravityField()
        //touchGravity?.position = point
        //touchGravity?.strength = -1
        //scene.addChild(touchGravity!)
    }
    
    func userTouchMove(point : CGPoint) {
        //touchGravity?.position = point
    }
    
    func userReleaseTouch(point : CGPoint) {
        //touchGravity?.removeFromParent()
        //touchGravity = nil
    }
    
    func userTap(point: CGPoint) {
        particle.size = CGSize(width: 25, height: 25)
        particle.position = point
        particleR.size = CGSize(width: 15, height: 15)
        particleR.position = point
    }
    
    func userSwipe(point : CGPoint, toPoint : CGPoint) {
        particle.size = CGSize(width: 25, height: 25)
        particle.position = point
        particleR.size = CGSize(width: 15, height: 15)
        particleR.position = toPoint
        
        let dx : CGFloat = toPoint.x - point.x
        let dy : CGFloat = toPoint.y - point.y
        // Add the swipe gravity points
        for i in 0..<numSwipeGravityPoints {
            let g : SKFieldNode = SKFieldNode.radialGravityField()
            let strengthFraction : CGFloat = CGFloat (1 - (i / numSwipeGravityPoints))
            let positionFraction : CGFloat = CGFloat(i / numSwipeGravityPoints)
            g.strength = Float((-1) * swipeStrength * strengthFraction)
            g.position.x = point.x + dx * positionFraction
            g.position.y = point.y + dy * positionFraction
            swipeGravity.append(g)
        }
        swipeStartTime = NSDate().timeIntervalSince1970
    }
    
    func userSwirl(point : CGPoint, radius : CGFloat) {
        particle.position = point
        particle.size = CGSize(width: radius * 2, height: radius * 2)
        particleR.position = point
    }
    
    class Wave {
        private let birthTime : TimeInterval
        private let lifeSpan : TimeInterval = 9
        private let touchingRadius : CGFloat = 9
        private let maxVelocity : CGFloat = 100
        private let originPoint : CGPoint
        private let numPointsInWave : Int
        public var pointsOfCircle : [SKNode] = []
        private let massOfPoint : CGFloat
        private let startingRadius : CGFloat
        private let circle : SKShapeNode
        private let scene : SKScene
        private let category : UInt32
        private let collisionMask : UInt32
        
        private let startColorComponent : CGFloat
        private let endColorComponent : CGFloat
        
        private var toBeDestroyedVar : Bool = false
        
        init(scene : SKScene, originPoint : CGPoint, startingRadius : CGFloat, numPointsInWave : Int, massOfPoint : CGFloat, startColorComponent : CGFloat, endColorComponent : CGFloat, category : UInt32, collisionMask : UInt32) {
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
            self.category = category
            self.collisionMask = collisionMask
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
                physicsPoint.physicsBody?.linearDamping = 0.1
                physicsPoint.physicsBody?.categoryBitMask = category
                physicsPoint.physicsBody?.collisionBitMask = collisionMask
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
                // CAP THE VELOCITY OF THE POINT
                
                let vx : CGFloat = point.physicsBody!.velocity.dx
                let vy : CGFloat = point.physicsBody!.velocity.dy
                let pointVelocityTotal : CGFloat = CGFloat(sqrt(vx*vx + vy*vy))
                if pointVelocityTotal > maxVelocity {
                    let cappingConstant : CGFloat = 0.005
                    let c = (pointVelocityTotal - maxVelocity) * cappingConstant
                    let vector : CGVector = CGVector(dx: -vx*c, dy: -vy*c)
                    point.physicsBody?.applyForce(vector)
                    
//                    point.physicsBody?.velocity.dx = cos(theta) * maxVelocity
//                    point.physicsBody?.velocity.dy = sin(theta) * maxVelocity
                }
                
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
        
        func isTouching(wave : Wave) -> Bool {
            if (wave.birthTime == self.birthTime) {
                return false
            }
            //var index = 0
            for i in 0...(pointsOfCircle.count - 1) {
                let point1 = self.pointsOfCircle[i]
                for di in -3...3 {
                    let el = i + di
                    if el >= 0 && el < pointsOfCircle.count {
                        let point2 = wave.pointsOfCircle[el]
                        let xDist = point1.position.x - point2.position.x
                        let yDist = point1.position.y - point2.position.y
                        let dist = sqrt(xDist*xDist + yDist*yDist)
                        if dist < touchingRadius {
                            return true
                        }
                    }
                }
            }
            return false
        }
        
        func getRandomCirclePos() -> CGPoint {
            let randIndex = arc4random_uniform(_ : UInt32(pointsOfCircle.count))
            return pointsOfCircle[Int(randIndex)].position
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
    
    class Proton : SKSpriteNode {
        
        private var currentScene : SKScene?
        private let sizeDimension : CGFloat = 10
        //private let category : UInt32
        
        required init?(coder aDecoder: NSCoder) {
            super.init(texture: SKTexture(imageNamed: "ball"), color: UIColor(), size: CGSize(width: sizeDimension, height: sizeDimension))
            currentScene = SKScene()
            position = CGPoint()
            size = CGSize()
        }
        
        init(scene: SKScene, pos : CGPoint, vel : CGVector, category : UInt32, collisionMask : UInt32) {
            super.init(texture: SKTexture(imageNamed: "ball"), color: UIColor(), size: CGSize(width: sizeDimension, height: sizeDimension))
            texture = SKTexture(imageNamed: "ball")
            currentScene = scene
            position = pos
            size = CGSize(width: sizeDimension, height: sizeDimension)
            physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "ball"), size: size)
            physicsBody?.velocity = vel
            physicsBody?.mass = 1
            physicsBody?.pinned = false
            physicsBody?.affectedByGravity = false
            physicsBody?.isDynamic = true
            physicsBody?.linearDamping = 1.0
            physicsBody?.restitution = 1.0
            //self.category = category
            physicsBody?.categoryBitMask = category
            physicsBody?.collisionBitMask = category
            currentScene?.addChild(self)
        }
        
        func randomMovement(withBiasToward point : CGPoint) {
            // This is a "random" "walk" "with" "a" "by-ias"
            let moveConstant : CGFloat = 0.50
            var d = CGFloat((10.5 * drand48()) - 5.23) * moveConstant
            let dx = d * (point.x - position.x)
            d = CGFloat((10.5 * drand48()) - 5.23) * moveConstant
            let dy = d * (point.y - position.y)
            let randomWalkWithBias = CGVector(dx: dx, dy: dy)
            physicsBody?.applyForce(randomWalkWithBias)
        }
    }
    
}

