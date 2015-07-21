//
//  Coin.swift
//  Untitled
//
//  Created by Jottie Brerrin on 7/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Coin: CCNode {
  var collected: Bool = false
  func didLoadFromCCB(){
    physicsBody.sensor = true
  }
  
  func collect(){
    AudioServicesPlaySystemSound(1352)
    collected = true
    animationManager.runAnimationsForSequenceNamed("Collect")

    
  }
}