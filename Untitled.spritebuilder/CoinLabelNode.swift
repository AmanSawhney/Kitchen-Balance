//
//  CoinNode.swift
//  Untitled
//
//  Created by Jottie Brerrin on 7/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class CoinLabelNode: CCNode {
  //
  weak var label: CCLabelTTF!
  
  func didLoadFromCCB(){
    cascadeOpacityEnabled = true
    opacity = 0.0
  }
  
  func updateLabel(coins: Int){
    label.string = "\(coins)"
    opacity = 1.0
    var delay = CCActionDelay(duration: 1)
    var fade = CCActionFadeOut(duration: 0.5)
    runAction(CCActionSequence(array: [delay, fade]))
  }
}