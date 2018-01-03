import Foundation
//import UIKit
//yoyo

enum Levels : Int {

case PureEnergy = 0,
Particles,
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
  case .Particles:
    return "Particles"
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

}

class Universe {

  var level : Levels
  var complexity : Int
  var game : Game

  init() {
    level = Levels.PureEnergy
    complexity = 0
    game = PureEnergyGame()
  }

  func playGame() {
    game.startGame()
  }

}
