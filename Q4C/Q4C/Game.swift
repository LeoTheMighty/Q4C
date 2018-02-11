//
//  Game.swift
//  Q4C
// let prot = SKSpriteNode(imageNamed: "ball")

//  Created by Leonid Belyi on 12/20/17.
//  Copyright © 2017 SoLux. All rights reserved.
//

import Foundation
import SpriteKit

public protocol Game {
    
    /*
    * Plays the actual game, using the UIView information with GameScene
    * Different for every single type of game
    */
    func startGame();
    
    /*
    *
    *
    */
    func resumeGame();
    
    func saveGame();
    
    /*
     * Use this to update your game. You can use the time interval with relation to
     * your starting time to precisely calculate where things should be (ie if you
     * move an object in a circle and have the position as a function of time, you
     * can put in the (currentTime - startTime) and that will give you the elapsed time)
     * Anything that happens without the user doing anything will also go here.
     */
    func update(currentTime : TimeInterval);
    
    /*
     * Use these three methods to change the game based on what the user does
     * Start off with just comment using these and we can figure it out from there
     */
    func userTap(point : CGPoint);
    
    func userSwipe(point : CGPoint);
    
    func userSwirl(point : CGPoint);
    
    func userPress(point : CGPoint);
    
    func userTouchMove(point : CGPoint);
    
    func userReleaseTouch(point : CGPoint);
}
