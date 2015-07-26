//
//  ScoreNode.swift
//  Untitled
//
//  Created by Jottie Brerrin on 7/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class ScoreNode: CCNode {
  
  enum displayState{
    case Perfect, Good, Fair, Poor
  }
  
  weak var scoreLabel: CCLabelTTF!
  weak var rotationLabel: CCLabelTTF!
  
  var onStreak = false
  var streakCounter: Int = 0 {
    didSet {
      switch streakCounter {
      case 120:
        balanceValue = 5.0
        onStreak = true
        multiplier = 2
      case 420:
        multiplier = 3
      case 720:
        multiplier = 4
      case 1020:
        multiplier = 5
      default:
        break
      }
    }
  }
  
  var balanceValue: Double = 5.0
  var multiplier: Int = 1{
    didSet {
      switch multiplier{
      case 2:
        animationManager.runAnimationsForSequenceNamed("Combo")
        color = CCColor(ccColor3b: ccColor3B(r: 136, g: 43, b: 196))
        rotationLabel.string = "Combo! x10"
        //start the particles
      case 3:
        animationManager.runAnimationsForSequenceNamed("Combo")
        color = CCColor(ccColor3b: ccColor3B(r: 136, g: 43, b: 196))
        rotationLabel.string = "Combo! x15"
      case 4:
        animationManager.runAnimationsForSequenceNamed("Combo")
        color = CCColor(ccColor3b: ccColor3B(r: 136, g: 43, b: 196))
        rotationLabel.string = "Combo! x20"
      case 5:
        animationManager.runAnimationsForSequenceNamed("Combo")
        color = CCColor(ccColor3b: ccColor3B(r: 136, g: 43, b: 196))
        rotationLabel.string = "Combo! x25"
      default:
        break
      }
    }
  }
  
  var state : displayState = .Perfect {
    didSet{
      switch state{
      case .Perfect:
        balanceValue = 5.0
        color = CCColor(ccColor3b: ccColor3B(r: 49, g: 203, b: 0))
        OALSimpleAudio.sharedInstance().stopAllEffects()
        OALSimpleAudio.sharedInstance().playEffect("8bits/goodSound.mp3", loop: true)
        rotationLabel.string = "Perfect x5"
        //make the particles invisible
      case .Good:
        balanceValue = 3.0
        color = CCColor(ccColor3b: ccColor3B(r: 1, g: 23, b: 104))
        OALSimpleAudio.sharedInstance().stopAllEffects()
        OALSimpleAudio.sharedInstance().playEffect("8bits/goodSound.mp3", loop: true)
        rotationLabel.string = "Good x3"
        //make the particles invisible
      case .Fair:
        balanceValue = 1.0
        streakMultiplierSorce = 1
        color = CCColor(ccColor3b: ccColor3B(r: 0, g: 166, b: 237))
        OALSimpleAudio.sharedInstance().stopAllEffects()
        OALSimpleAudio.sharedInstance().playEffect("8bits/Retro Game FX 3.mp3", loop: true)
        rotationLabel.string = "Ok x1"
        //make the particles invisible
      case .Poor:
        balanceValue = 0.75
        color = CCColor(ccColor3b: ccColor3B(r: 246, g: 81, b: 29))
        OALSimpleAudio.sharedInstance().stopAllEffects()
        OALSimpleAudio.sharedInstance().playEffect("8bits/Retro Game FX 3.mp3", loop: true)
        rotationLabel.string = "Uh-oh! x0.75"
        //make the particles invisible
      }
    }
  }
  
  func didLoadFromCCB(){
    cascadeColorEnabled = true
    state = .Perfect
  }
  
  func displayRotation(rotation: Float){
    if !onStreak{
      if abs(rotation) < 1.5{
        if state != .Perfect{
          state = .Perfect
        }
        streakCounter++
      } else if abs(rotation) < 2{
        streakCounter++
      }else if abs(rotation) >= 2 && abs(rotation) < 4{
        if state != .Good{
          state = .Good
        }
        streakCounter++
      } else if abs(rotation) >= 4.5 && abs(rotation) < 8 {
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
    } else {
      if abs(rotation) > 5.5 {
        streakCounter++
      } else {
        streakCounter = 0
        onStreak = false
        //run streak lost
      }
    }
  }
  
  func updateScore(score: Double){
    scoreLabel.string = "\(Int(score))"
  }
  
}
