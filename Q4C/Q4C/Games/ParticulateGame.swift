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
 *
 */
class ParticulateGame : Game {
    func saveData() {
        
    }
    
    func loadData() {
        
    }
    
   
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
        
    
    
    }
    
    func update(currentTime : TimeInterval) {
        
    }
    
    
    
    
    
    //these also are not used
    func userTap(point : CGPoint) {
        
    }
    
    func userSwipe(point : CGPoint, toPoint : CGPoint) {
        
    }
    
    func userSwirl(point : CGPoint, radius : CGFloat) {
        
    }
    
    func userPress(point : CGPoint) {
        
        
    }
    
    func userTouchMove(point : CGPoint) {
        
    }
    
    func userReleaseTouch(point : CGPoint) {
        
    }
    
    
    
    class Proton {
        private var scene : SKScene
        private var lifeTime : TimeInterval = 35 //how long the proton lasts
        private var origin : CGPoint //where the proton is born
        private let startColorComponent : CGFloat = 155/256 //the color of the proton
        private var prot : SKSpriteNode //image that is the proton
        
        init(scene : SKScene, lifeTime : TimeInterval, prot : SKSpriteNode) {
            
            self.prot = SKSpriteNode(imageNamed: "ball")
            self.scene = scene
            
            prot.physicsBody = SKPhysicsBody(texture : prot.texture!, size: CGSize(width: 0.5, height: 0.5))
        
            origin = CGPoint(x: -scene.size.width/2, y: -scene.size.height/2)
            
            
            //self.startColorComponent = startColorComponent
           
            scene.addChild(prot)
        }
        
   
    }

//what it do? These are not used in pure energy
 
 }
