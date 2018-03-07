//
//  BiologicalGame.swift
//  Q4C
//
//  Created by Leonid Belyi on 12/26/17.
//  Copyright © 2017 SoLux. All rights reserved.
//

import Foundation
import SpriteKit
/*swipe to fight, swirl to mate, tap to collect food
 *
 *
 *content: energy in form of food, aqueous solution, mutation opportunities
 */
//emergent properties: eventually there should be an ecosystem of cells, perhaps some are better at pairing, while some are stronger but faster

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
 *cells, crumbs, ripples to imitate fluid
 *note: cells should be animated transparent amoeba
 * Transition (to next):
 *
 *
 */
class BiologicalGame : Game {
    
    private var scene : SKScene
    private var cells : [Cell] = []
    private var numCells : Int = 0
    private var originPoint : CGPoint //should be random
    
    private var startTime : TimeInterval = 0
    private let backgroundColorComponent : CGFloat = 48/255
    private var complexity : Int //get value from previous game
    private var complexityCounter : SKLabelNode
    
    init() {
        complexity = 0
        originPoint = CGPoint()
        scene = SKScene()
        complexityCounter = SKLabelNode()
    }
    
    func saveData() {
        
    }
    
    func loadData() {
        
    }
    

    
    func update(currentTime : TimeInterval) {
        
    }
    
    
    
    class Cell {
       private var energy : Int = 30
       private var dna : Int = 15
       private var longevity : TimeInterval = 60
        private var pairingSite : CGPoint
        private var amoeba : SKSpriteNode
        init(scene : SKScene, currentTime : TimeInterval) {
            pairingSite = CGPoint()
            amoeba = SKSpriteNode()
        }
        //energy
      //DNA: manifested by which one swiped at other wins, duration of life,
      //
    
        func reproduce(){
            //this should allow two cells to make three
        
        }
        
        func pair(){
            //this should allow two to come together, strengths are sum, speeds are lessened, requires more
            //energy but does not increase longevity
            //use pairing site variable
        }
    }
    



    class Energy {
        //takes form of smaller crumb particle which is engulfed allows for more motion but shortens longevity
    }
    
    func userTap(point : CGPoint) {
        //this action is mutualistic
    }
    
    func userSwipe(point : CGPoint, toPoint : CGPoint) {
         //this action attacks
    }
    
    func userSwirl(point : CGPoint, radius : CGFloat) {
        //this action exchanges DNA between several
    }
    
    func userPress(point : CGPoint) {
        
    }
    
    func userTouchMove(point : CGPoint) {
        
    }
    
    func userReleaseTouch(point : CGPoint) {
        
    }
}
