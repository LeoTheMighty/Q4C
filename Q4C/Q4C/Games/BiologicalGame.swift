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
class BiologicalGame : Game {
    func saveData() {
        
    }
    
    func loadData() {
        
    }
    

    
    func update(currentTime : TimeInterval) {
        
    }
    /*private var scene : SKScene
    
    private var protons : [Proton] = []
    private var numProtons : Int = 0
    private var originPoint : CGPoint = CGPoint()
    
    private var startTime : TimeInterval = 0
    private let timeBetweenProtons : TimeInterval = 3.0
    
    private let backgroundColorComponent : CGFloat = 48/255
    private var complexityCounter : SKLabelNode!*/
    
    private var scene : SKScene
    private var cells : [Cell] = []
    private var originPoint
    
    
    class Cell {
       private var energy : Int = 30
       private var dna : Int = 15
       private var longevity : TimeInterval = 60
        
       init(scene : SKScene, currentTime : TimeInterval) {
            
        }
        //energy
      //DNA: manifested by which one swiped at other wins, duration of life,
      //
    
        func reproduce{
        
        }
        }
    }
    
    class Energy {
        //takes form of smaller crumb particle which is engulfed allows for more motion but shortens longevity
    }
    
    func userTap(point : CGPoint) {
        //this action is mutualistic
    }
    
    func userSwipe(point : CGPoint) {
        //this action attacks
    }
    
    func userSwirl(point : CGPoint) {
        //this action exchanges DNA between several
    }
    
    func userPress(point : CGPoint) {
        
    }
    
    func userTouchMove(point : CGPoint) {
        
    }
    
    func userReleaseTouch(point : CGPoint) {
        
    }
}
