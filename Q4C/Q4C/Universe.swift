import Foundation
import SpriteKit

enum Levels : Int {

case PureEnergy = 0,
Particulate,
Molecular,
Biological,
Agricultural,
Industrial,
Digital,
SpaceAge,
Intergalactic,
Universal

func name() -> String {
  switch self {
  case .PureEnergy:
    return "Pure Energy"
  case .Particulate:
    return "Particulate"
  case .Molecular:
    return "Molecular"
  case .Biological:
    return "Biological"
  case .Agricultural:
    return "Agricultural"
  case .Industrial:
    return "Industrial"
  case .Digital:
    return "Digital"
  case .SpaceAge:
    return "Space Age"
  case .Intergalactic:
    return "Intergalactic"
  case .Universal:
    return "Universal"
    }
}

func threshold() -> Int {
  var complexityLevel = 10

  for index in 0...10 {
    complexityLevel*=10
    if index == self.rawValue {
      return complexityLevel
    }
  }

  //error if it reaches here
  return -1
}

}

class Universe {

    var level : Levels
    var complexity : Int
    var game : Game
    var scene : SKScene
    
    init() {
        self.scene = SKScene()
        level = Levels.Universal
        complexity = 0
        game = PureEnergyGame(scene: scene, currentTime: NSDate().timeIntervalSince1970)
    }
    
    init(scene : SKScene) {
        self.scene = scene
        level = Levels.PureEnergy
        complexity = 0
        game = PureEnergyGame(scene : scene, currentTime : NSDate().timeIntervalSince1970)
    }
    
    init(scene : SKScene, levelName : String) {
        self.scene = scene
        complexity = 0
        if levelName == "Pure Energy" {
            level = Levels.PureEnergy
            game = PureEnergyGame(scene: scene, currentTime: NSDate().timeIntervalSince1970)
        }
        else  if levelName == "Particulate" {
            level = Levels.Particulate
            game = ParticulateGame(scene: scene, currentTime: NSDate().timeIntervalSince1970)
        }
        else {
            level = Levels.Molecular
            game = MolecularGame(currentTime: NSDate().timeIntervalSince1970)
        }
    }
    
    func playGame() {
        game = PureEnergyGame(scene: scene, currentTime: NSDate().timeIntervalSince1970)
    }

}
