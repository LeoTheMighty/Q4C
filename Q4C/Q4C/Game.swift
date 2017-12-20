//
//  Game.swift
//  Q4C
//
//  Created by Leonid Belyi on 12/20/17.
//  Copyright © 2017 SoLux. All rights reserved.
//

import Foundation

public protocol Game {
  /*
  * Plays the actual game, using the UIView information with GameScene
  * Different for every single type of game
  */
  func playGame()
}
