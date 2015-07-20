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
    collected = true
    var audio = OALSimpleAudio.sharedInstance()
    audio.playEffect("Source/Resources/Sounds/coins/coin1")
    animationManager.runAnimationsForSequenceNamed("Collect")

    
  }
}