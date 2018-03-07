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
    
    private var ifCanBeTap : Bool = false
    private let tapRadius : CGFloat = 5
    private let swirlEndRadius : CGFloat = 25
    private var ifTouching : Bool = false
    private var touchPos : CGPoint = CGPoint(x: 0, y: 0)
    private var furthestPressPos : CGPoint = CGPoint(x: 0, y: 0)
    private var furthestPressDist : CGFloat = 0
    
    private var universe : Universe = Universe()
    
    private let pauseButtonNode = SKSpriteNode(imageNamed: "pauseButton")
    private var timePaused : CGFloat = 0
    private var pausedTime : CGFloat = -1
    var isGamePaused : Bool = false
    
    let menu : MenuScene = MenuScene()

    private let backgroundColorComponent : CGFloat = 48 / 255
    private let waveColorComponent : CGFloat = 255 / 255
    
    override func didMove(to view: SKView) {
        
        self.scaleMode = .fill
        
        universe = Universe(scene: self, levelName: "Pure Energy")
        
        //BOUNDS OF THE VIEW
        print("Width is " + String.init(describing : self.view?.bounds.width))
        print("Height is " + String.init(describing : self.view?.bounds.height))
        
        //HOW TO SHOW A SKLABELNODE (delete when not needed)
//        let label1 = SKLabelNode(text: "test text node")
//        label1.fontColor = UIColor(red: waveColorComponent, green: waveColorComponent, blue: waveColorComponent, alpha: 1)
//        label1.fontName = "PingFangTC-Ultralight"
//        label1.position = CGPoint(x : 0, y : 0)
//        label1.color = UIColor(red: backgroundColorComponent, green: backgroundColorComponent, blue: backgroundColorComponent, alpha: 1)
        //addChild(label1)
        
        //HOW TO SHOW A UILABEL
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: (self.view?.bounds.width)!, height: (self.view?.bounds.height)!))
//        label.center = CGPoint(x : (self.view?.bounds.width)! / 2, y : (self.view?.bounds.height)! / 2)
//        label.textAlignment = NSTextAlignment.center
//        label.text = "Test text"
//        label.textColor = UIColor(red: waveColorComponent, green: waveColorComponent, blue: waveColorComponent, alpha: 1)
//        label.font = UIFont(name: "PingFangTC-Ultralight", size: 15)
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
    }
    
    func userTap(atPoint pos : CGPoint) {
        universe.game.userTap(point: pos)
    }
    
    func userSwipe(atPoint pos1 : CGPoint, toPoint pos2 : CGPoint) {
        universe.game.userSwipe(point: pos1, toPoint: pos2)
    }
    
    func userSwirl(atPoint pos : CGPoint, with radius : CGFloat) {
        universe.game.userSwirl(point: pos, radius: radius)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if pauseButtonNode.contains(pos) {
            if !self.isPaused {
                self.isPaused = true
                self.view?.isUserInteractionEnabled = true
                menu.presentMenu(parentScene : self)
            }
            else {
                self.isPaused = false
                menu.hideMenu()
            }
        }
        else {
            // Fundamental action
            universe.game.userPress(point: pos)
            
            ifTouching = true
            touchPos = pos
            ifCanBeTap = true
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        // Fundamental action
        universe.game.userTouchMove(point : pos)
        
        // Update the furthest Pos
        let dist = GameScene.dist(point1: touchPos, point2: pos)
        if dist > tapRadius {
            ifCanBeTap = false
        }
        if dist > furthestPressDist {
            furthestPressPos = pos
            furthestPressDist = dist
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        // Fundamental action
        universe.game.userReleaseTouch(point : pos)
        let dist = GameScene.dist(point1: touchPos, point2: pos)
        
        if ifTouching {
            if ifCanBeTap {
                if dist < tapRadius {
                    userTap(atPoint: touchPos)
                }
            }
            else if dist < swirlEndRadius {
                // Is a swirl
                // The point is the midway point between furthest and start
                // radius is half the distance between them
                let midwayPoint = GameScene.midwayPoint(point1: touchPos, point2: furthestPressPos)
                let radius = furthestPressDist / 2
                userSwirl(atPoint: midwayPoint, with: radius)
            }
            else {
                // Is a swipe
                userSwipe(atPoint: touchPos, toPoint: pos)
            }
        }
        
        touchPos = CGPoint(x: 0, y: 0)
        ifTouching = false
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
        universe.game.update(currentTime: actualCurrentTime)
    }
    
    static func vectorFromPoints(point1 : CGPoint, point2 : CGPoint) -> CGVector {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return CGVector(dx: dx, dy: dy)
    }
    
    static func midwayPoint(point1 : CGPoint, point2 : CGPoint) -> CGPoint {
        let x = point1.x + point2.x
        let y = point1.y + point2.y
        return CGPoint(x: x / 2, y: y / 2)
    }
    
    static func dist(point1 : CGPoint, point2 : CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return CGFloat(sqrt(dx*dx + dy*dy))
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
