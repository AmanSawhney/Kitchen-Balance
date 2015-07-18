
import Foundation

enum typeOfObject {
  case RollingPin, Pan, Plate
}
var whichObject: typeOfObject!

class MainScene: CCNode {
  weak var hand: CCNode!
  weak var object: CCSprite!
  weak var gamePhysicsNode: CCPhysicsNode!
  weak var scoreLabel: CCLabelTTF!
  var currentTouchLocation: CGPoint!
  var pivot: CCPhysicsJoint!
  var score: Double = 0 {
    didSet{
      scoreLabel.string = "\(Int(score))"
    }
  }
  let scorePerUpdate = 32.0
//  var 
  var rotationMultiplier: Double = 1
  var done = false {
    didSet {
      var shitScreen = CCBReader.load("ShitScreen", owner:self) as! ShitScreen
      shitScreen.position.x = -self.contentSize.width
      self.addChild(shitScreen)
    }
  }
  
  
  var screenWidth = UIScreen.mainScreen().bounds.width
  var screenHeight = UIScreen.mainScreen().bounds.height
  
  func didLoadFromCCB() {
    
//    gamePhysicsNode.debugDraw = true
    userInteractionEnabled = true
  }
  
  override func onEnter() {
    super.onEnter()
    
    if let whichObject = whichObject{
      
      switch whichObject{
      case .RollingPin:
        object = CCBReader.load("Objects/RollingPin") as! CCSprite
      case .Plate:
        object = CCBReader.load("Objects/Plate") as! CCSprite
      case .Pan:
        object = CCBReader.load("Objects/Pan") as! CCSprite
      default:
        object = CCBReader.load("Objects/RollingPin") as! CCSprite
      }
    } else {
      object = CCBReader.load("Objects/RollingPin") as! CCSprite

    }

    hand = CCBReader.load("Objects/Hand")
    hand.scale = 0.6
    hand.position = ccp(screenWidth/2, 0)
//    hand.physicsBody.type = CCPhysicsBodyType(rawValue: UInt(1))!
    object.position = ccp(screenWidth/2, hand.contentSizeInPoints.height * CGFloat(hand.scale) * (CGFloat(1) - hand.anchorPoint.y))
    
    hand.zOrder = 2
    object.zOrder = 1
    
    gamePhysicsNode.addChild(hand)
    gamePhysicsNode.addChild(object)
    
    pivot = CCPhysicsJoint(pivotJointWithBodyA: object.physicsBody, bodyB: hand.physicsBody, anchorA: ccp(20, 0))
//    pivot = CCPhysicsJoint(distanceJointWithBodyA: object.physicsBody, bodyB: hand.physicsBody, anchorA: ccp(0,0), anchorB: object.position, minDistance: CGFloat(0), maxDistance: CGFloat(0))
    pivot.collideBodies = false
    
    var randomRotation = Double(arc4random_uniform(2)) + 1.0
    object.rotation = Float(arc4random_uniform(2) == 1 ? randomRotation : -randomRotation)
//    println(object.rotation)
    
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    currentTouchLocation = touch.locationInWorld()
  }
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    hand.position.x = CGFloat(clampf(Float(hand.position.x - (currentTouchLocation.x - touch.locationInWorld().x)), Float(0.0), Float(screenWidth)))
    currentTouchLocation = touch.locationInWorld()
  }
  override func update(delta: CCTime) {
    hand.position.y = 0
//    object.physicsBody.velocity.y = 0
    
    
    score += rotationMultiplier * scorePerUpdate
    
    //        println(Int(pin.rotation))
    if Int(object.rotation) <= -130 || (Int(object.rotation) >= 110) {
      if !done {
        done = true
        pivot.invalidate()
      }
      //      var mainScene : CCScene =  CCBReader.loadAsScene("Easy")
      //      CCDirector.sharedDirector().replaceScene(mainScene)
    }
//    if currentTouchLocation != nil {
//      var random = arc4random_uniform(300)
//      if hand.position.x > CCDirector.sharedDirector().viewSize().width/2 {
//        object.physicsBody.applyImpulse(ccp(-CGFloat(random),0))
//      } else if hand.position.x < CCDirector.sharedDirector().viewSize().width/2 {
//        object.physicsBody.applyImpulse(ccp(CGFloat(random),0))
//      }
//    }
  }
  
  func restart(){
    var playScene = CCBReader.loadAsScene("MainScene")
    CCDirector.sharedDirector().replaceScene(playScene)
  }
  
}
