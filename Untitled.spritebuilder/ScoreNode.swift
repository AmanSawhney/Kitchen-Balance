//
//  ScoreNode.swift
//  Untitled
//
//  Created by Jottie Brerrin on 7/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class ScoreNode: CCNode {
  
  enum displayState: Double{
    case Streak = 10.0, Perfect = 5.0, Good = 3.0, Fair = 1.0, Poor = 0.75
  }
  
  weak var scoreLabel: CCLabelTTF!
  weak var rotationLabel: CCLabelTTF!
  var delegate: StreakDelegate?
  
  var state : displayState = .Perfect {
    didSet{
      switch state{
      case .Streak:
        delegate?.startStreak()
        color = CCColor(ccColor3b: ccColor3B(r: 104, g: 0, b: 186))
        rotationLabel.string = "Streak x10"
      case .Perfect:
        delegate?.stopStreak()
        color = CCColor(ccColor3b: ccColor3B(r: 49, g: 203, b: 0))
        rotationLabel.string = "Perfect x5"
        //make the particles invisible
      case .Good:
        delegate?.stopStreak()
        color = CCColor(ccColor3b: ccColor3B(r: 1, g: 23, b: 104))
        rotationLabel.string = "Good x3"
        //make the particles invisible
      case .Fair:
        delegate?.stopStreak()
        color = CCColor(ccColor3b: ccColor3B(r: 0, g: 166, b: 237))
        rotationLabel.string = "Ok x1"
        //make the particles invisible
      case .Poor:
        delegate?.stopStreak()
        color = CCColor(ccColor3b: ccColor3B(r: 246, g: 81, b: 29))
        rotationLabel.string = "Uh-oh! x0.75"
        //make the particles invisible
      }
    }
  }
  
  var streakCounter = 0 {
    didSet{
      if streakCounter > 300 && state != .Streak{
        state = .Streak
      }
    }
  }
  
  func didLoadFromCCB(){
    cascadeColorEnabled = true
    state = .Perfect
  }
  
  func displayRotation(rotation: Float){
    
    if abs(rotation) < 4.5{
      streakCounter++
      if state == .Streak{

      } else if abs(rotation) < 1.5 {
        if state != .Perfect{
          state = .Perfect
        }
      } else {
        if state != .Good{
          state = .Good
        }
      }
      //handle streak, good, and perfect
    } else if abs(rotation) >= 4.5 && abs(rotation) < 8{
      if state != .Fair{
        state = .Fair
      }
      streakCounter = 0
    } else if abs(rotation) >= 9 {
      if state != .Poor{
        state = .Poor
      }
      streakCounter = 0
    }

  }
  
  func updateScore(score: Double){
    scoreLabel.string = "\(Int(score))"
  }
  
}

protocol StreakDelegate{
  func startStreak()
  func stopStreak()
}
