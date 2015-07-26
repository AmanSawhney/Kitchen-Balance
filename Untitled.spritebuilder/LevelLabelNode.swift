//
//  LevelLabel.swift
//  Untitled
//
//  Created by Jottie Brerrin on 7/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class LevelLabelNode: CCNode {
  
  var label: CCLabelTTF!
  
  var level: Int = 1{
    didSet{
      label.string = "Level \(self.level)"
    }
  }
  
  
}