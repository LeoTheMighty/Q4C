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
    
    let pauseButtonNode = SKSpriteNode(imageNamed: "pauseButton")
    var isGamePaused : Bool = false
    
    let menu : MenuScene = MenuScene()
    
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
    
    override func didMove(to view: SKView) {
        
        self.scaleMode = .fill
        
        //initialize the physics circle
        self.backgroundColor = UIColor(red : backgroundColorComponent, green : backgroundColorComponent, blue : backgroundColorComponent, alpha : 1)
        originPoint = CGPoint(x: -self.size.width / 2, y: -self.size.height / 2)
        startTime = NSDate().timeIntervalSince1970
        startGravity.strength = startGravityStrength
        startGravity.position = originPoint
        addChild(startGravity)
        
        //BOUNDS OF THE VIEW
        print("Width is " + String.init(describing : self.view?.bounds.width))
        print("Height is " + String.init(describing : self.view?.bounds.height))
        
        //HOW TO SHOW A SKLABELNODE (delete when not needed)
        let label1 = SKLabelNode(text: "test text node")
        label1.fontColor = UIColor(red: waveColorComponent, green: waveColorComponent, blue: waveColorComponent, alpha: 1)
        label1.fontName = "PingFangTC-Ultralight"
        label1.position = CGPoint(x : 0, y : 0)
        label1.color = UIColor(red: backgroundColorComponent, green: backgroundColorComponent, blue: backgroundColorComponent, alpha: 1)
        //addChild(label1)
        
        //HOW TO SHOW A UILABEL
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: (self.view?.bounds.width)!, height: (self.view?.bounds.height)!))
        label.center = CGPoint(x : (self.view?.bounds.width)! / 2, y : (self.view?.bounds.height)! / 2)
        label.textAlignment = NSTextAlignment.center
        label.text = "Test text"
        label.textColor = UIColor(red: waveColorComponent, green: waveColorComponent, blue: waveColorComponent, alpha: 1)
        label.font = UIFont(name: "PingFangTC-Ultralight", size: 15)
        //self.view?.addSubview(label)
        
        //Keeping the aspect ratio for the pause button
        if self.size.width > self.size.height {
            pauseButtonNode.size = CGSize(width: self.size.height / 20, height: self.size.height / 20)
        }
        else {
            pauseButtonNode.size = CGSize(width : self.size.width / 20, height : self.size.width / 20)
        }
        
        //Add the pause button
        pauseButtonNode.color = UIColor(red: waveColorComponent, green: waveColorComponent, blue: waveColorComponent, alpha: 1)
        pauseButtonNode.position = CGPoint(x : -(self.size.width / 2) + pauseButtonNode.size.width * 3 / 2, y : (self.size.height / 2) - pauseButtonNode.size.height * 3 / 2)
        addChild(pauseButtonNode)
        
        //Start off with a big ol' wave
        waves.append(Wave(scene: self, originPoint: originPoint, startingRadius: radiusOfUnaffectedCircle, numPointsInWave: numPointsInWave, massOfPoint: massOfPoint, startColorComponent: waveColorComponent, endColorComponent: backgroundColorComponent))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if pauseButtonNode.contains(pos) {
            if !self.isPaused {
                self.isPaused = true
                self.view?.isUserInteractionEnabled = false
                menu.presentMenu(parentScene : self)
            }
            else {
                self.isPaused = false
                menu.hideMenu()
                
            }
        }
        else {
            touchGravity = SKFieldNode.radialGravityField()
            touchGravity?.position = pos
            touchGravity?.strength = -1
            addChild(touchGravity!)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        touchGravity?.position = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        touchGravity?.removeFromParent()
        touchGravity = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
        let actualCurrentTime = NSDate().timeIntervalSince1970
        let elapsedTime = actualCurrentTime - startTime
        
        if Int(elapsedTime / timeBetweenWaves) > numWaves {
            waves.append(Wave(scene: self, originPoint: originPoint, startingRadius: radiusOfUnaffectedCircle, numPointsInWave: numPointsInWave, massOfPoint: massOfPoint, startColorComponent : waveColorComponent, endColorComponent : backgroundColorComponent))
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
    
    static func vectorFromPoints(point1 : CGPoint, point2 : CGPoint) -> CGVector {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return CGVector(dx: dx, dy: dy)
    }
}

class MenuScene : SKScene {
    
    var parentScene : SKScene
    let screenBounds : CGRect
    let dimView : SKView
    var alphaColor : CGFloat = 0.25
    var isShown : Bool = false
    var isAnimatingMenu : Bool = false
    
    override init() {
        //placeholder, because the scene isn't placed onto anything yet
        parentScene = SKScene()
        
        //Initializing the dimming SKView
        screenBounds = UIScreen.main.bounds
        dimView = SKView(frame : screenBounds)
        super.init(size : dimView.bounds.size)
        self.backgroundColor = UIColor(white: -1/255, alpha: alphaColor)
        dimView.allowsTransparency = true
        
        
        self.scaleMode = .fill
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //alphaColor += 0.01
        //self.backgroundColor = UIColor(white: -1/255, alpha: alphaColor)
    }
    
    func presentMenu(parentScene : SKScene) {
        self.parentScene = parentScene
        
        //Dim the rest of the screen
        parentScene.view?.addSubview(dimView)
        dimView.presentScene(self)
        
        isAnimatingMenu = true
        let menu : SKSpriteNode = SKSpriteNode(imageNamed: "ball")
        menu.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        menu.size = CGSize(width: 0, height: 0)
        
        let endWidth : CGFloat
        let endHeight : CGFloat
        
        if self.size.width > self.size.height {
            endHeight = 7 * self.size.height / 8
            endWidth = 7 * self.size.height / 8
        }
        else {
            endHeight = 7 * self.size.width / 8
            endWidth = 7 * self.size.width / 8
        }
        
        let openMenuWidth = SKAction.resize(toWidth: endWidth, duration: 0.6)
        let openMenuHeight = SKAction.resize(toHeight: endHeight, duration: 0.6)
        openMenuWidth.timingMode = SKActionTimingMode.easeInEaseOut
        openMenuHeight.timingMode = SKActionTimingMode.easeInEaseOut
        let openMenu = SKAction.group([openMenuWidth, openMenuHeight])
        
        addChild(menu)
        menu.run(openMenu)
    }
    
    func hideMenu() {
        self.removeFromParent()
        dimView.removeFromSuperview()
    }
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
