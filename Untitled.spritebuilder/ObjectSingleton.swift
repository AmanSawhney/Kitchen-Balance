//
//  ObjectSingleton.swift
//  Untitled
//
//  Created by Jottie Brerrin on 8/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Object {
  var id: String
  var cost: Int
  var spritePath: String
  var imagePath: String
  var hasBeenPurchased: Bool
  var drops: Int{
    didSet{
      NSUserDefaults.standardUserDefaults().setInteger(self.drops, forKey: "\(self.id)")
    }
  }
  var highScore: Double{
    didSet{
      NSUserDefaults.standardUserDefaults().setDouble(self.highScore, forKey: "\(self.id)")
    }
  }
  
  init(id: String, cost: Int){
    self.id = id
    self.cost = cost
    self.spritePath = "\(id)"
    self.imagePath = "\(id)"
    self.hasBeenPurchased = NSUserDefaults.standardUserDefaults().boolForKey("\(id)")
    self.drops = NSUserDefaults.standardUserDefaults().integerForKey("\(id)")
    self.highScore = NSUserDefaults.standardUserDefaults().doubleForKey("\(id)")
  }
  
  func purchase(){
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "\(id)")
  }
  
  func recordScore(score: Double) -> Bool{
    if score > highScore {
      self.highScore = score
      return true
    }
    return false
  }

}

class ObjectSingleton{
  
  static let sharedInstance = ObjectSingleton()
  
  var currentIndex = NSUserDefaults.standardUserDefaults().integerForKey("objectIndex"){
    didSet{
      NSUserDefaults.standardUserDefaults().setInteger(self.currentIndex, forKey: "objectIndex")
    }
  }
  
  private var objectArray = [
  Object(id: "rollingPin", cost: 0),
  Object(id: "knife", cost: 100),
  Object(id: "gun", cost: 250)
  ]

  func getCurrentObject() -> Object{
    return Object(id: objectArray[currentIndex].id, cost: objectArray[currentIndex].cost)
  }
  func recordDrop(score: Double){
    objectArray[currentIndex].recordScore(score)
  }
  func purchaseCurrentItem(){
    objectArray[currentIndex].purchase()
  }
  func nextItem() -> Bool{
    if currentIndex < objectArray.count - 1{
      currentIndex++
    }
    return currentIndex < objectArray.count - 1
  }
  func prevItem() -> Bool{
    if currentIndex > 0{
      currentIndex--
    }
    return currentIndex > 0
  }
  

  
}