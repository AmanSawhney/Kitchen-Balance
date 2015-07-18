//
//  ScoreNode.swift
//  Untitled
//
//  Created by Jottie Brerrin on 7/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class ScoreNode: CCNode {
  weak var scoreLabel: CCLabelTTF!
  weak var rotationLabel: CCLabelTTF!
  
  func didLoadFromCCB(){
    cascadeColorEnabled = true
  }
  
  func displayRotation(rotation: Double){
    if abs(rotation) < 5{
      //perfect
    } else if abs(rotation) < 15{
      //good
    } else if abs(rotation) < 30 {
      //fair
    } else {
      //poor
    }
  }
  
  func updateScore(score: Double){
    scoreLabel.string = "\(Int(score))"
  }
}