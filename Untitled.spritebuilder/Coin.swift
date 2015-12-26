//
//  Coin.swift
//  Untitled
//
//  Created by Aman Sawhney on 12/26/15.
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
    animationManager.runAnimationsForSequenceNamed("Collect")
  }
}