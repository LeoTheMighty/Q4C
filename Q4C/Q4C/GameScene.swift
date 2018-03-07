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
    
    
    private var universe : Universe = Universe()
    
    let pauseButtonNode = SKSpriteNode(imageNamed: "pauseButton")
    var isGamePaused : Bool = false
    
    let menu : MenuScene = MenuScene()

    private let backgroundColorComponent : CGFloat = 48 / 255
    private let waveColorComponent : CGFloat = 255 / 255
    
    override func didMove(to view: SKView) {
        
        self.scaleMode = .fill
        
        universe = Universe(scene: self, levelName: "Particulate")
        
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
    
    func userSwipe(atPoint pos : CGPoint) {
        universe.game.userSwipe(point: pos)
    }
    
    func userSwirl(atPoint pos : CGPoint) {
        universe.game.userSwirl(point: pos)
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
            universe.game.userPress(point: pos)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        universe.game.userTouchMove(point : pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        universe.game.userReleaseTouch(point : pos)
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
