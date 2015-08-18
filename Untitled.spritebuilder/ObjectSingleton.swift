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
  var ccbPath: String
  var imagePath: String
  var hasBeenPurchased: Bool
  var drops: Int{
    didSet{
      NSUserDefaults.standardUserDefaults().setInteger(self.drops, forKey: "\(self.id)Drops")
    }
  }
  var highScore: Double{
    didSet{
      NSUserDefaults.standardUserDefaults().setDouble(self.highScore, forKey: "\(self.id)Highscore")
    }
  }
  
  init(id: String, cost: Int){
    
    self.id = id
    self.cost = cost
    self.ccbPath = "Objects/\(id)"
    self.imagePath = "Art/Objects/\(id).png"
    self.hasBeenPurchased = NSUserDefaults.standardUserDefaults().boolForKey("\(id)Purchased")
    self.drops = NSUserDefaults.standardUserDefaults().integerForKey("\(id)Drops")
    self.highScore = NSUserDefaults.standardUserDefaults().doubleForKey("\(id)Highscore")
  }
  
  func purchase(){
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "\(id)Purchased")
  }
  
  func recordScore(score: Double) -> Bool{
    drops++
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
  
  init(){
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "RollingPinPurchased")
  }
  
  private var objectArray = [
  Object(id: "RollingPin", cost: 0),
  Object(id: "Knife", cost: 100),
  Object(id: "Gun", cost: 250)
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
    return currentIndex == objectArray.count - 1
  }
  func prevItem() -> Bool{
    if currentIndex > 0{
      currentIndex--
    }
    return currentIndex == 0
  }
  

  
}