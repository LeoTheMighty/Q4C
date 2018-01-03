//
//  GameScene.swift
//  Q4C
//
//  Created by Leonid Belyi on 12/19/17.
//  Copyright © 2017 SoLux. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let universe : Universe = Universe()
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
//    private var firstSpot : CGPoint?
//    private var secondSpot : CGPoint?
//    private var line : SKShapeNode?
    private var touchGravity : SKFieldNode?
    private var radiusOfUnaffectedCircle : CGFloat = 50
    private var pointsOfCircle : [SKNode] = []
    private let massOfPoint : CGFloat = 0.5
    //private var circlePath : CGMutablePath = CGMutablePath.init()
    private var circle : SKShapeNode = SKShapeNode()
    
    override func didMove(to view: SKView) {
        //initialize the physics circle
        initCircle()
        
//        firstSpot = CGPoint(x: -self.size.width / 2, y: -self.size.height / 2)
//        secondSpot = CGPoint(x: -self.size.width / 2, y: -self.size.height / 2)
//        line = SKShapeNode()
//        addChild(line!)
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        
        touchGravity = SKFieldNode.radialGravityField()
        touchGravity?.position = pos
        touchGravity?.strength = -1
        addChild(touchGravity!)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
        touchGravity?.removeFromParent()
        touchGravity = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //line!.removeFromParent()
        updateCircle()
//        secondSpot!.x += 3
//        firstSpot!.y += 3
//        let midWaySpot : CGPoint = CGPoint(x: (firstSpot!.x + secondSpot!.x)/2, y: (firstSpot!.y + secondSpot!.y)/2)
//        let origin = CGPoint(x: -self.size.width / 2, y: -self.size.height / 2)
//        let path = CGMutablePath.init()
//        path.move(to: firstSpot!)
//        //path.addLine(to: secondSpot!)
//        path.addQuadCurve(to: secondSpot!, control: origin)
//        line!.path = path
        //line!.strokeColor = UIColor.white
        //line!.lineWidth = 2
        //addChild(line!)
    }
    
    func initCircle() {
        let circlePath : CGMutablePath = CGMutablePath.init()
        
        for angle in 0...360 {
            let physicsPoint = SKSpriteNode()
            physicsPoint.position.x = cos(CGFloat(angle)*CGFloat.pi/180) * radiusOfUnaffectedCircle
            physicsPoint.position.y = sin(CGFloat(angle)*CGFloat.pi/180) * radiusOfUnaffectedCircle
            physicsPoint.texture = SKTexture(image: #imageLiteral(resourceName: "hollowBall"))
            //physicsPoint.physicsBody = SKPhysicsBody(circleOfRadius: 0.01)
            //physicsPoint.physicsBody = SKPhysicsBody(circleOfRadius: 0.01)
            physicsPoint.physicsBody = SKPhysicsBody(texture: physicsPoint.texture!, size: CGSize(width: 0.09, height: 0.09))
            physicsPoint.physicsBody?.mass = massOfPoint
            physicsPoint.physicsBody?.pinned = false
            physicsPoint.physicsBody?.affectedByGravity = false
            physicsPoint.physicsBody?.isDynamic = true
            physicsPoint.isHidden = false
            pointsOfCircle.append(physicsPoint)
            addChild(physicsPoint)
            physicsPoint.physicsBody!.applyForce(CGVector(dx: 3*physicsPoint.position.x, dy: 3*physicsPoint.position.y))
            physicsPoint.position = CGPoint(x: physicsPoint.position.x - self.size.width / 2, y: physicsPoint.position.y - self.size.height / 2)
            if angle == 0 {
                circlePath.move(to: physicsPoint.position)
            }
            else {
                circlePath.addQuadCurve(to: physicsPoint.position, control: CGPoint(x: 0, y: 0))
            }
        }
        
        circle.path = circlePath
        circle.strokeColor = UIColor.white
        circle.lineWidth = 2
        addChild(circle)
    }
    
    func updateCircle() {
        circle.removeFromParent()
        let circlePath : CGMutablePath = CGMutablePath.init()
        var nextIndex = 1
        circlePath.move(to: pointsOfCircle[0].position)
        for point in pointsOfCircle {
            //point.physicsBody!.applyImpulse(CGVector(dx: 1, dy: 1))
            point.physicsBody!.applyForce(vectorFromPoints(point1: point.position, point2: circlePath.currentPoint))
            point.physicsBody!.applyForce(vectorFromPoints(point1: point.position, point2: pointsOfCircle[nextIndex].position))
            circlePath.addLine(to: point.position)
            if nextIndex == 359 {
                nextIndex = 0
            }
            else {
                nextIndex += 1
            }
        }
        circle.path = circlePath
        circle.lineWidth = 2
        addChild(circle)
    }
    
    func vectorFromPoints(point1 : CGPoint, point2 : CGPoint) -> CGVector {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return CGVector(dx: dx, dy: dy)
    }
}
