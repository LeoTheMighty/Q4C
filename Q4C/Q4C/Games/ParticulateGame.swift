//
//  ParticulateGame.swift
//  Q4C
//
//  Created by Leonid Belyi on 12/26/17.
//  Copyright © 2017 SoLux. All rights reserved.
//
// Uh guh Hye man

import Foundation
import SpriteKit

class ParticulateGame : Game {
   
    //issues still: color und size?

    //size of radius, shape, use ball png -> how? SKTexture...
    //also must code in the dwindling energy reserve as protons form
    
    private var scene : SKScene
    
    private var protons : [Proton] = []
    private var numProtons : Int = 0
    private var originPoint : CGPoint = CGPoint()
    
    private var startTime : TimeInterval = 0
    private let timeBetweenProtons : TimeInterval = 3.0
    
    private let backgroundColorComponent : CGFloat = 48/255
    private var complexityCounter : SKLabelNode!
    
    init(scene : SKScene, currentTime : TimeInterval){
        self.startTime = currentTime
        self.scene = scene
    
        scene.backgroundColor = UIColor(red : backgroundColorComponent, green : backgroundColorComponent, blue : backgroundColorComponent, alpha : 1)
        originPoint = CGPoint(x: -scene.size.width / 2, y: -scene.size.height / 2)
        startTime = NSDate().timeIntervalSince1970
        //make the label for complexity appear onscreen
        complexityCounter = SKLabelNode(fontNamed: "Chalkduster")
        complexityCounter.text = "Complexity: 0"
        complexityCounter.horizontalAlignmentMode = .right
        complexityCounter.position = CGPoint(x: 0, y: 0)
        //addChild(complexityCounter)
        
        //proton.append(
    
    
    }
    
    func update(currentTime : TimeInterval) {
        
    }
    
    
    
    
    
   
    
    func userPress(point : CGPoint) {
        
        
    }
    
    func userTouchMove(point : CGPoint) {
        
    }
    
    func userReleaseTouch(point : CGPoint) {
        
    }
    
    
    
   class Proton {
        //establish the properties of class proton
        private var lifeTime : TimeInterval = 35
        private var origin : CGPoint
        private let startColorComponent : CGFloat
        private let endColorComponent : CGFloat
        //private let scene : SKScene
        private var texture: SKTexture?
       // private let size : 
    
    
    
    init(scene : SKScene, startColorComponent : CGFloat, endColorComponent : CGFloat, lifeTime : TimeInterval, origin : CGPoint, prot : SKSpriteNode) {
        
        let prot = SKSpriteNode(imageNamed: "ball")

        /*prot.position.x =
            prot.position.y =*/
            prot.texture = SKTexture()
            //prot.size = CGSizeMake
            prot.physicsBody = SKPhysicsBody(texture : prot.texture!, size: CGSize(width: 0.5, height: 0.5))
        
            self.origin = origin
            self.startColorComponent = startColorComponent
            self.endColorComponent = endColorComponent
           }
        
        
    
    }
        //these also are not used
        func userTap(point : CGPoint) {
            
        }
        
        func userSwipe(point : CGPoint) {
            
        }
        
        func userSwirl(point : CGPoint) {
 
        }

//what it do? These are not used in pure energy
 func startGame() {
 
 }
 
 func resumeGame() {
 
 }
 
 func saveGame() {
 
 }


 }
