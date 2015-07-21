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
    case Perfect = 5.0, Good = 3.0, Fair = 1.0, Poor = 0.75
  }
  
  weak var scoreLabel: CCLabelTTF!
  weak var rotationLabel: CCLabelTTF!

  
  var state : displayState = .Perfect {
    didSet{
      switch state{
      case .Perfect:
        color = CCColor(ccColor3b: ccColor3B(r: 49, g: 203, b: 0))
        rotationLabel.string = "Perfect! x 5"
        
        OALSimpleAudio.sharedInstance().stopAllEffects()

        OALSimpleAudio.sharedInstance().playEffect("8bits/goodSound.mp3", loop: true)
      case .Good:
        color = CCColor(ccColor3b: ccColor3B(r: 1, g: 23, b: 104))
        OALSimpleAudio.sharedInstance().stopAllEffects()
        OALSimpleAudio.sharedInstance().playEffect("8bits/goodSound.mp3", loop: true)
        rotationLabel.string = "Good! x 3"
      case .Fair:
        color = CCColor(ccColor3b: ccColor3B(r: 0, g: 166, b: 237))
        OALSimpleAudio.sharedInstance().stopAllEffects()
         OALSimpleAudio.sharedInstance().playEffect("8bits/Retro Game FX 3.mp3", loop: true)
        rotationLabel.string = "Ok! x 1"
      case .Poor:
        color = CCColor(ccColor3b: ccColor3B(r: 246, g: 81, b: 29))
        OALSimpleAudio.sharedInstance().stopAllEffects()
        OALSimpleAudio.sharedInstance().playEffect("8bits/Retro Game FX 3.mp3", loop: true)
        rotationLabel.string = "Uh-oh! x 0.75"
      }
    }
  }
  
  override func update(delta: CCTime) {

  }
  
  func didLoadFromCCB(){
    cascadeColorEnabled = true
    state = .Perfect
  }
  
  func displayRotation(rotation: Float){
    if abs(rotation) < 1.5 && state != .Perfect{
      state = .Perfect
    } else if abs(rotation) >= 2 && abs(rotation) < 4 && state != .Good{
      state = .Good
    } else if abs(rotation) >= 4.5 && abs(rotation) < 8 && state != .Fair {
      state = .Fair
    } else if abs(rotation) >= 9 && state != .Poor {
      state = .Poor
    }
  }
  
  
  
  func updateScore(score: Double){
    scoreLabel.string = "\(Int(score))"
    let defaults = NSUserDefaults.standardUserDefaults()
    var highscore = defaults.doubleForKey("highscore")
    if score > highscore {
        defaults.setDouble(score, forKey: "highscore")
    }
  }
}